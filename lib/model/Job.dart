


class Job{
  String id;
  bool hired;

  Job(this.id,this.hired);



  toJson() {
    return {
      "id": id,
      "hired":hired,
    };
  }
}