import 'package:flutter/material.dart';
class AddAppBar extends StatelessWidget {
  const AddAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Container(
              padding:  const EdgeInsets.all(10),
              decoration:  BoxDecoration(
                  color:  Colors.white,
                  boxShadow: const [BoxShadow(color: Colors.black26,blurRadius: 6)],
                  borderRadius: BorderRadius.circular(15)
              ),
              child:  const Icon(Icons.arrow_back_ios,size: 28,),
            ),
          ),

        ],
      ),

    );
  }
}
