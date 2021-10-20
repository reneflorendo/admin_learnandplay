import 'package:firebase_auth/firebase_auth.dart';
import 'package:learnandplay/Models/UserTopics.dart';
import 'package:learnandplay/Models/Users.dart';

import 'Models/AdminUsers.dart';

Users userCurrentInfo= new Users(id: "", email: "", name: "", year: "",isActive: false, photo: "");
AdminUsers adminUserCurrentInfo= new AdminUsers(id: "", email: "", name: "",isActive: false, photo: "");
UserTopics userTopics = new UserTopics(id: "", topicId:"", userTopicId: "", topic: "", currentPage: 0, status: "");