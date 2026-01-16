// widgets/optimized_searchable_dropdown.dart
import 'dart:async';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/style_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OptimizedSearchableDropdown extends StatefulWidget {
  final String hintText;
  final ModelData? selectedItem;
  final ValueChanged<ModelData?> onChanged;
  final Future<PaginationModel<ModelData>> Function(String query, int page)
      searchFunction;
  final Future<ModelData?> Function(String)? fetchItemById;
  final bool border;
  final String? Function(ModelData?)? validator;
  final Widget? leadingIcon;
  final EdgeInsetsGeometry? padding;
  final double? height;
  final bool showClearButton;
  final String? defaultValueId;

  const OptimizedSearchableDropdown({
    super.key,
    required this.hintText,
    required this.selectedItem,
    required this.onChanged,
    required this.searchFunction,
    this.fetchItemById,
    this.border = true,
    this.validator,
    this.leadingIcon,
    this.padding,
    this.height,
    this.showClearButton = true,
    this.defaultValueId,
  });

  @override
  State<OptimizedSearchableDropdown> createState() =>
      _OptimizedSearchableDropdownState();
}

class _OptimizedSearchableDropdownState
    extends State<OptimizedSearchableDropdown> {
  // Controladores
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Estado COMPARTIDO - Solo una fuente de verdad
  late DropdownState _state;
  StreamController<DropdownState>? _stateStreamController;
  Stream<DropdownState>? _stateStream;

  // Para controlar el estado del modal
  bool _isModalOpen = false;

  @override
  void initState() {
    super.initState();

    // Inicializar estado
    _state = DropdownState(
      items: [],
      selectedItem: widget.selectedItem,
      isLoading: false,
      isLoadingMore: false,
      hasMore: true,
      currentPage: 1,
      currentQuery: '',
    );

    // Crear stream para compartir estado
    _stateStreamController = StreamController<DropdownState>.broadcast();
    _stateStream = _stateStreamController!.stream;

    // Cargar valor por defecto si existe
    if (widget.defaultValueId != null && widget.fetchItemById != null) {
      _loadDefaultValue();
    }

    _scrollController.addListener(_onScroll);

    // Emitir estado inicial
    _emitState();
  }

  @override
  void didUpdateWidget(OptimizedSearchableDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Actualizar si cambió externamente
    if (widget.selectedItem != oldWidget.selectedItem) {
      _updateState(selectedItem: widget.selectedItem);
    }

    // Cargar nuevo valor por defecto si cambió
    if (widget.defaultValueId != oldWidget.defaultValueId &&
        widget.defaultValueId != null &&
        widget.fetchItemById != null) {
      _loadDefaultValue();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _stateStreamController?.close();
    super.dispose();
  }

  // Actualizar estado y emitir cambios
  void _updateState({
    List<ModelData>? items,
    ModelData? selectedItem,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? currentQuery,
  }) {
    // Crear nuevo estado
    final newState = _state.copyWith(
      items: items,
      selectedItem: selectedItem,
      isLoading: isLoading,
      isLoadingMore: isLoadingMore,
      hasMore: hasMore,
      currentPage: currentPage,
      currentQuery: currentQuery,
    );

    // Actualizar estado local
    if (mounted) {
      setState(() {
        _state = newState;
      });
    }

    // EMITIR SIEMPRE al stream
    _emitState();
  }

  // Emitir estado al stream
  void _emitState() {
    if (_stateStreamController != null && !_stateStreamController!.isClosed) {
      _stateStreamController!.add(_state);
    }
  }

  Future<void> _loadDefaultValue() async {
    try {
      final defaultItem = await widget.fetchItemById!(widget.defaultValueId!);
      if (defaultItem != null && mounted) {
        _updateState(selectedItem: defaultItem);
        widget.onChanged(defaultItem);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error cargando valor por defecto: $e');
      }
    }
  }

  void _onScroll() {
    if (!_isModalOpen ||
        _state.isLoading ||
        _state.isLoadingMore ||
        !_state.hasMore) {
      return;
    }

    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.8) {
      _loadMoreData();
    }
  }

  Future<void> _loadInitialData({bool forceReload = false}) async {
    if (_state.isLoading && !forceReload) return;

    _updateState(
      isLoading: true,
      currentPage: 1,
    );

    try {
      final result = await widget.searchFunction(_state.currentQuery, 1);

      if (mounted) {
        _updateState(
          items: result.items,
          hasMore: result.hasMore,
          currentPage: result.currentPage,
          isLoading: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en _loadInitialData: $e');
      }
      _showErrorSnackbar('Error cargando datos: $e');
      if (mounted) {
        _updateState(isLoading: false);
      }
    }
  }

  Future<void> _loadMoreData() async {
    if (_state.isLoadingMore || !_state.hasMore) return;

    _updateState(isLoadingMore: true);

    try {
      final result = await widget.searchFunction(
          _state.currentQuery, _state.currentPage + 1);

      // Pequeño delay para mejor UX
      await Future.delayed(const Duration(milliseconds: 100));

      if (mounted) {
        final newItems = List<ModelData>.from(_state.items)
          ..addAll(result.items);
        _updateState(
          items: newItems,
          hasMore: result.hasMore,
          currentPage: result.currentPage,
          isLoadingMore: false,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error en _loadMoreData: $e');
      }
      _showErrorSnackbar('Error cargando más datos: $e');
      if (mounted) {
        _updateState(isLoadingMore: false);
      }
    }
  }

  void _onSearchChanged(String query) {
    Timer(const Duration(milliseconds: 500), () {
      if (_state.currentQuery != query) {
        _updateState(
          currentQuery: query,
          currentPage: 1,
          hasMore: true,
        );
        _loadInitialData(forceReload: true);
      }
    });
  }

  void _showErrorSnackbar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _clearSelection() {
    // Crear un NUEVO estado explícitamente con selectedItem: null
    final newState = DropdownState(
      items: _state.items,
      selectedItem: null, // <-- Explícitamente null
      isLoading: _state.isLoading,
      isLoadingMore: _state.isLoadingMore,
      hasMore: _state.hasMore,
      currentPage: _state.currentPage,
      currentQuery: _state.currentQuery,
    );

    // Actualizar estado local
    if (mounted) {
      setState(() {
        _state = newState;
      });
    }

    // Notificar al widget padre
    widget.onChanged(null);

    // Limpiar controller
    _searchController.clear();

    // Recargar datos si el modal está abierto
    if (_isModalOpen) {
      _loadInitialData(forceReload: true);
    }

    // Emitir estado
    _emitState();
  }

  void _showSearchModal() {
    _searchController.text = _state.currentQuery;
    _isModalOpen = true;

    // Cargar datos iniciales siempre que se abra el modal
    _loadInitialData(forceReload: true);

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      isDismissible: true,
      enableDrag: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return _SearchModalContent(
          stateStream: _stateStream!,
          searchController: _searchController,
          scrollController: _scrollController,
          hintText: widget.hintText,
          leadingIcon: widget.leadingIcon,
          showClearButton: widget.showClearButton,
          onSearchChanged: _onSearchChanged,
          onClearSelection: _clearSelection,
          onItemSelected: (item) {
            _updateState(selectedItem: item);
            widget.onChanged(item);
            Navigator.pop(context);
          },
          onLoadMore: _loadMoreData,
        );
      },
    ).then((_) {
      _searchController.clear();
      _updateState(currentQuery: '');
      _isModalOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = widget.height ?? StylesApp(context).sizeTextFormField.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Campo del dropdown
        GestureDetector(
          onTap: _showSearchModal,
          child: Container(
            height: height,
            decoration: widget.border
                ? BoxDecoration(
                    color: StyleColor.white,
                    border: Border.all(
                      color: _state.selectedItem != null
                          ? StyleColor.cosmicBlue.withValues(alpha: .5)
                          : StyleColor.black,
                      width: _state.selectedItem != null ? 1.5 : 1,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  )
                : BoxDecoration(
                    color: StyleColor.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
            child: Padding(
              padding: widget.padding ??
                  const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 8.0,
                  ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.leadingIcon != null) ...[
                    widget.leadingIcon!,
                    const SizedBox(width: 8),
                  ],
                  Expanded(
                    child: Text(
                      _state.selectedItem?.label ?? widget.hintText,
                      style: StylesApp(context).textStyleBody14.copyWith(
                            color: _state.selectedItem != null
                                ? Colors.black
                                : Colors.grey.shade600,
                            fontWeight: _state.selectedItem != null
                                ? FontWeight.w500
                                : FontWeight.normal,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (_state.selectedItem != null && widget.showClearButton)
                    IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: _clearSelection,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      tooltip: 'Limpiar selección',
                    ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.arrow_drop_down,
                    color: Colors.grey.shade600,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Widget del modal que usa STREAM para recibir estado
class _SearchModalContent extends StatefulWidget {
  final Stream<DropdownState> stateStream;
  final TextEditingController searchController;
  final ScrollController scrollController;
  final String hintText;
  final Widget? leadingIcon;
  final bool showClearButton;
  final Function(String) onSearchChanged;
  final VoidCallback onClearSelection;
  final Function(ModelData) onItemSelected;
  final VoidCallback onLoadMore;

  const _SearchModalContent({
    required this.stateStream,
    required this.searchController,
    required this.scrollController,
    required this.hintText,
    this.leadingIcon,
    required this.showClearButton,
    required this.onSearchChanged,
    required this.onClearSelection,
    required this.onItemSelected,
    required this.onLoadMore,
  });

  @override
  State<_SearchModalContent> createState() => _SearchModalContentState();
}

class _SearchModalContentState extends State<_SearchModalContent> {
  late DropdownState _currentState;
  StreamSubscription<DropdownState>? _stateSubscription;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _currentState = DropdownState(
      items: [],
      selectedItem: null,
      isLoading: true,
      isLoadingMore: false,
      hasMore: true,
      currentPage: 1,
      currentQuery: '',
    );
    // Suscribirse al stream de estado
    _stateSubscription = widget.stateStream.listen((state) {
      if (mounted) {
        setState(() {
          _currentState = state;
          _isInitialized = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: Colors.grey.shade300),
              ),
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.hintText,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        if (_currentState.selectedItem != null &&
                            widget.showClearButton)
                          IconButton(
                            icon: const Icon(Icons.clear_all, size: 20),
                            onPressed: () {
                              widget.searchController.clear();
                              widget.onClearSelection();
                            },
                            tooltip: 'Limpiar selección',
                          ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: widget.searchController,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: 'Buscar...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    suffixIcon: widget.searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              widget.searchController.clear();
                              widget.onSearchChanged('');
                            },
                          )
                        : null,
                  ),
                  onChanged: widget.onSearchChanged,
                ),
              ],
            ),
          ),

          // Lista de resultados - se actualiza automáticamente con el stream
          Expanded(
            child: _buildResultsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsList() {
    // Estado inicial (antes de recibir datos del stream)
    if (!_isInitialized ||
        _currentState.isLoading && _currentState.items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Sin resultados
    if (_currentState.items.isEmpty && !_currentState.isLoading) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 16),
              Text(
                _currentState.currentQuery.isEmpty
                    ? 'No hay elementos disponibles'
                    : 'No se encontraron resultados para "${_currentState.currentQuery}"',
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Lista con items
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollEndNotification) {
          // Verificar si llegamos al final
          if (widget.scrollController.position.pixels >=
              widget.scrollController.position.maxScrollExtent * 0.8) {
            widget.onLoadMore();
          }
        }
        return false;
      },
      child: ListView.builder(
        controller: widget.scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _currentState.items.length + (_currentState.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          // Ítem de "cargar más"
          if (index == _currentState.items.length) {
            return _buildLoadMoreIndicator();
          }

          final item = _currentState.items[index];
          final isSelected = _currentState.selectedItem?.value == item.value;

          return Material(
            color: isSelected
                ? StyleColor.blueLight.withValues(alpha: .1)
                : Colors.transparent,
            child: ListTile(
              leading: widget.leadingIcon,
              title: Text(
                item.label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? StyleColor.cosmicBlue : Colors.black,
                ),
              ),
              trailing: isSelected
                  ? Icon(
                      Icons.check,
                      color: StyleColor.cosmicBlue,
                    )
                  : null,
              onTap: () => widget.onItemSelected(item),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadMoreIndicator() {
    if (!_currentState.hasMore) return Container();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Mostrar loading cuando está cargando más
          if (_currentState.isLoadingMore)
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor:
                    AlwaysStoppedAnimation<Color>(StyleColor.cosmicBlue),
              ),
            ),

          // Mostrar mensaje cuando hay más para cargar
          if (!_currentState.isLoadingMore)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Desliza para cargar más',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// Modelo de estado inmutable
@immutable
class DropdownState {
  final List<ModelData> items;
  final ModelData? selectedItem;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int currentPage;
  final String currentQuery;

  const DropdownState({
    required this.items,
    this.selectedItem,
    required this.isLoading,
    required this.isLoadingMore,
    required this.hasMore,
    required this.currentPage,
    required this.currentQuery,
  });

  DropdownState copyWith({
    List<ModelData>? items,
    ModelData? selectedItem,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? currentPage,
    String? currentQuery,
  }) {
    return DropdownState(
      items: items ?? this.items,
      selectedItem: selectedItem ?? this.selectedItem,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      currentQuery: currentQuery ?? this.currentQuery,
    );
  }
}
