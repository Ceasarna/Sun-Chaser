class form {
  late String satisfaction;
  late String typeOfFeedback;
  late String writtenFeedback;

  form(String satisfaction, String typeOfFeedback, String writtenFeedback, String timestamp){
    this.satisfaction = satisfaction;
    this.typeOfFeedback = typeOfFeedback;
    this.writtenFeedback = writtenFeedback;
  }
}