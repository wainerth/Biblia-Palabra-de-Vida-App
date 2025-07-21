import 'package:biblia_palabra_de_vida_app/graphql-config/graphql_config.dart';
import 'package:biblia_palabra_de_vida_app/providers/providers.dart';
import 'package:biblia_palabra_de_vida_app/themes/styles_app.dart';
import 'package:biblia_palabra_de_vida_app/widgets/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class ProfileHeader extends StatefulWidget {
  final String avatarImg;
  final VoidCallback onSelectImage;

  const ProfileHeader({
    super.key,
    required this.avatarImg,
    required this.onSelectImage,
  });

  @override
  State<ProfileHeader> createState() => _ProfileHeaderState();
}

class _ProfileHeaderState extends State<ProfileHeader> {
  ImageProvider _getImageProvider() {
    if (widget.avatarImg.isEmpty) {
      return AssetImage('assets/no-image.jpg');
    } else {
      setState(() {});
      return NetworkImage(
        '${GraphQLConfig.urlServidor}${widget.avatarImg}?timestamp=${DateTime.now().millisecondsSinceEpoch}',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final dataUser = userProvider.currentUser;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: const AssetImage("assets/elipsisTop.png"),
          fit: BoxFit.fill,
          alignment: Alignment.center,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            left: 15,
            child: Container(
                height: 35.sp,
                width: 35.sp,
                decoration: BoxDecoration(
                    color: Color(0XFFFD8C43),
                    borderRadius: BorderRadius.circular(35.sp)),
                child: IconButton(
                    constraints: BoxConstraints(maxHeight: 35.0),
                    padding: EdgeInsets.all(0),
                    iconSize: 35.sp,
                    color: Colors.white,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      size: 35.sp,
                    ))),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: widget.onSelectImage,
                child: Center(
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: 160, minHeight: 160),
                          width: double.infinity,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(160),
                              border: Border.all(
                                  width: 6.0, color: Color(0XFF12CBC4))),
                          child: ClipOval(
                            child: Image(
                              image: _getImageProvider(),
                              fit: BoxFit.cover,
                              height: 160,
                              width: 160,
                              alignment: Alignment.topCenter,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          right: 0,
                          child: Container(
                            width: 40.0,
                            height: 40.0,
                            decoration: BoxDecoration(
                                color: Color(0XFF12CBC4),
                                borderRadius: BorderRadius.circular(40)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                softWrap: true,
                dataUser!.name.split(' ')[0][0].toUpperCase() + dataUser.name.split(' ')[0].substring(1),
                style: StylesApp(context).textStyleTitleOrange,
              ),
              SizedBox(
                height: 10.0,
              )
            ],
          ),
          Positioned(
              top: 10,
              right: 10,
              child: Column(
                children: [
                  Image.asset("assets/kawaii_fire.png"),
                  Text(
                    "${dataUser.energyPoints}",
                    style: StylesApp(context)
                        .textStyleBody4
                        .copyWith(color: Color(0XFFFD8C43)),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
