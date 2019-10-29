

class Project{
  String title;
  String description;
  String budget;
  String time;
  String fileUrl;
  String category;

  String agency;

  Project(this.title, this.description, this.budget, this.time, this.fileUrl,
      this.agency);

  toJson(){
    return {
      "title":title,
      "description":description,
      "budget":budget,
      "time":time,
      "fileUrl":fileUrl,
      "agency":agency
    };
  }


}