import 'package:flutter/material.dart';

import '../const/colors.dart';

class NoticePopupDialog extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onPressed;
  final Widget? child;

  const NoticePopupDialog({
    required this.message,
    required this.buttonText,
    required this.onPressed,
    this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        //Dialog 화면의 border
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        padding: EdgeInsets.all(20.0),
        width: MediaQuery.of(context).size.width * 0.7,
        height: 200.0,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
          borderRadius:
          BorderRadius.all(Radius.circular(12.0)), //Dialog 내부 컨테이너의 border
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              message,
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
            SizedBox(height: 20.0),
            SizedBox(
              height: 40.0,
              child: ElevatedButton(
                onPressed: onPressed,
                child: Text(
                  buttonText,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PRIMARY_COLOR,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
