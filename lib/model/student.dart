class StudentModel{

   int? id;
  String? name;
  String? age;
  String?place;
  String?mobile;
  String? imageurl;

  StudentModel({required this.id,required this.name,required this.age,required this.place, required this.mobile,this.imageurl});


   Map<String ,Object>toMap(){
  return {
    'id':id!,
    'name':name!,
    'place':place!,
    'mobile':mobile!,
  'imageurl':imageurl!
    
  };}
  static StudentModel fromMap(Map<String,Object?>student){
    return StudentModel(
        id: student['id'] as int,
        name: student['name'] as String,
        age: student['age'] as String,
        place: student['place'] as String,
        mobile: student['mobile'] as String,
        imageurl: student['image'] as String);
  
  }
 

}