import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat%20copy/service/database_service.dart';
import 'package:integritylink/src/features/core/screens/community_group_chat/service/database_service.dart';

class CommunityControllertest extends GetxController {
  static CommunityControllertest get instance => Get.find();

  Future<QuerySnapshot> getGroups() {
    return DatabaseServicetest().listOfGrps();
  }
}
