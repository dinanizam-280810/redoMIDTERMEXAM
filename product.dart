class Product {
  String? hsid;
  String? userid;
  String? hsname;
  String? hsdesc;
  String? hsprice;
  //String? user_email;
 // String? user_name;
  String? hsstate;
  String? hslocality;
  String? hslat;
  String? hslong;
  String? hsdate;

  Product(
      {required this.hsid,
      required this.hsname,
      required this.userid,
      required this.hsdesc,
      required this.hsprice,
      //required this.user_email,
      //required this.user_name,
      required this.hsstate,
      required this.hslocality,
      required this.hslat,
      required this.hslong,
      required this.hsdate});

  Product.fromJson(Map<String, dynamic> json) {
    hsid = json['hsid'];
    userid = json['userid'];
    hsname = json['hsname'];
    hsdesc = json['hsdesc'];
    hsprice = json['hsprice'];
    hsstate = json['hsstate'];
    hslocality = json['hslocality'];
    hslat = json['hslat'];
    hslong = json['hslong'];
    hsdate = json['hsdate'];
  }

   Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hsid'] = hsid;
    data['userid'] = userid;
    data['hsname'] = hsname;
    data['hsdesc'] = hsdesc;
    data['hsprice'] = hsprice;
    data['hsstate'] = hsstate;
    data['hslocality'] = hslocality;
    data['hslat'] = hslat;
    data['hslong'] = hslong;
    data['hsdate'] = hsdate;
    return data;
  }
}

