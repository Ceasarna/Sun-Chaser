class user{
  late int userID;
  late String username;
  late String email;

  user(int userID, String username, String email){
    this.userID = userID;
    this.username = username;
    this.email = email;
  }

  user emptyUser(){
    return user(0, "", "");
  }
  int getID(){
    return userID;
  }
}