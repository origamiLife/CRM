import 'package:origamilift/import/origami_view/language/translate_page.dart';
import '../../../main.dart';
import 'ENG.dart';
import 'TH.dart';

Future<String>? futureLoadData;
Future<String> loadData() async {
  await Future.delayed(const Duration(seconds: 1)); // Simulate a network call
  return 'Data Loaded';
}

void Translate() {
  if (selectedRadio == 1) {
    TH();
  } else if (selectedRadio == 2) {
    ENG();
  }
}

// origami view
String need = '';
String request = '';
String academy = '';
String language = '';
String job = '';
String logout = '';

// need view
String Search = '';
String Date = '';
String Amount = '';
String request_date = '';
String Priority = '';
String Department = '';
String all_Department = '';
String Project = '';
String all_project = '';
String Owner = '';
String all_Owner = '';
String Status1 = '';
String Empty = '';
String Save = '';

// Need Detail
String Subject  = '';
String Reason = '';
String Effective_date = '';
String Return_date = '';
String Division = '';
String Payto  = '';
String Account = '';
String Asset = '';
String Contact = '';
String Item = '';
String Detail = '';
String Quantity = '';
String Unit = '';
String Price = '';
String Price_Unit = '';
String Request = '';
String Add_Item = '';
String Close_Item = '';
String Error_Item = '';
String Close = '';
String Error_Detail = '';
String Type_something = '';
String Bill = '';
String No_Image = '';
String Add_Image = '';
String Baht = '';
String Total_price = '';
String Loading = '';
String Name = '';
String Position1 = '';
String Comment = '';
String No_Comment = '';
String ExitApp = '';
String NotNow = '';
String Confirm = '';
String Cancel = '';
String SearchFor = '';
String Next = '';
String Back = '';
String Exit = '';
String Ok = '';
String DescriptionT = '';
String CurriculumT = '';
String InstructorsT = '';
String DiscussionT = '';
String AnnouncementsT = '';
String Attach_FileT = '';
String CertificationT = '';
String Start = '';
String End = '';
String Enroll = '';
String Includes = '';
String Videos = '';
String Documents = '';
String Certificate = '';
String Students = '';
String What_you_learn = '';
String Favorite = '';
String Class = '';
String Resume = '';
String Courses = '';
String Show = '';
String Entries = '';
String Latest = '';
String to = '';
String of = '';
String Previoue = '';
String Pass  = '';
String For_this_Course = '';
String Quality_of_education = '';
String Download  = '';
String Pass_the_test  = '';
String Join_with_workshop = '';
String Verify_On = '';
String Times = '';
String Please_select = '';
String Not_found_favoite = '';
String Not_found_course = '';