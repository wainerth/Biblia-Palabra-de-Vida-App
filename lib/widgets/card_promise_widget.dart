import 'package:biblia_palabra_de_vida_app/class/preferences_manager.dart';
import 'package:biblia_palabra_de_vida_app/graphql-config/function_graphql/mutations.dart';
import 'package:biblia_palabra_de_vida_app/models/models.dart';
import 'package:biblia_palabra_de_vida_app/providers/authentication_provider.dart';
import 'package:biblia_palabra_de_vida_app/providers/user_provider.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/utils/utilities.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class CardPromiseWidget extends StatefulWidget {
  final PromiseCardModel onePromise;
  final PromiseModel? redeemedPromise;
  final Function(bool value) updateData;
  const CardPromiseWidget({
    super.key,
    required this.onePromise,
    this.redeemedPromise,
    required this.updateData,
  });

  @override
  State<CardPromiseWidget> createState() => _CardPromiseWidgetState();
}

class _CardPromiseWidgetState extends State<CardPromiseWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onePromise.hasViewed
          ? null
          : () async {
              LoadingService().showLoading(context);
              final userProvider =
                  Provider.of<UserProvider>(context, listen: false);
              final userData = userProvider.currentUser;
              try {
                final responseOpenPromise = await openOnePromise(
                    userData!.userId, widget.onePromise.id);
                if (responseOpenPromise.error != null) {
                  LoadingService().hideLoading();
                  await showCustomDialog(context,
                      message: responseOpenPromise.error!,
                      dialogType: DialogType.error);
                  return;
                }

                String? userToken = await PreferencesManager().getUserToken();

                await Provider.of<AuthenticationProvider>(context,
                        listen: false)
                    .loadProfileUser(userData.userId, userToken);
                LoadingService().hideLoading();
                widget.updateData(responseOpenPromise.data);
              } catch (e) {
                LoadingService().hideLoading();
                await showCustomDialog(context,
                    message: e.toString(), dialogType: DialogType.error);
                return;
              }
            },
      child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          child: widget.onePromise.hasViewed
              ? _buildRedeemedPromiseCard()
              : _buildPromiseCard()),
    );
  }

  Widget _buildPromiseCard() {
    return Container(
      key: ValueKey(1),
      decoration: BoxDecoration(
        color: Color(0XFFF3E9C6),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 4,
              spreadRadius: 0,
              offset: Offset(0, 4))
        ],
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(widget.onePromise.images.isNotEmpty
                  ? widget.onePromise.images
                  : ''),
              SizedBox(height: 16),
              Text(
                widget.onePromise.title,
                style: StylesApp(context).textStyleBodyOrange15,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                widget.onePromise.description,
                textAlign: TextAlign.center,
                style: StylesApp(context)
                    .textStyleBody12
                    .copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRedeemedPromiseCard() {
    return Container(
      key: ValueKey(2),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Color(int.parse("0XFF${widget.redeemedPromise!.color}")),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: .25),
              blurRadius: 8,
              spreadRadius: 0,
              offset: Offset(0, 4))
        ],
      ),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${widget.redeemedPromise!.book!.modernName} ${widget.redeemedPromise!.chapter!.chapter}:${widget.redeemedPromise!.verse!.verse}",
                    style: StylesApp(context)
                        .textStyleBody4
                        .copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.redeemedPromise!.verse!.text!,
                      textAlign: TextAlign.center,
                      style: StylesApp(context)
                          .textStyleBody14
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 20),
                  Image.asset("assets/star_complete.png",
                      width: 50, height: 50),
                  SizedBox(height: 10),
                  Text(
                    "Haz ganado una mini estrella\n ${widget.redeemedPromise!.energyPoint} Lms de energía",
                    textAlign: TextAlign.center,
                    style: StylesApp(context)
                        .textStyleBody12
                        .copyWith(color: StyleColor.yellowLight),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () async {
                await SharePlus.instance.share(ShareParams(
                  text:
                      "${widget.redeemedPromise!.book!.modernName} ${widget.redeemedPromise!.chapter!.chapter}:${widget.redeemedPromise!.verse!.verse}\n${widget.redeemedPromise!.verse!.text}.",
                  subject: "Promesa",
                ));
              },
              icon: Icon(Icons.share, color: Colors.white),
            ),
          ),
          
        ],
      ),
    );
  }
}
