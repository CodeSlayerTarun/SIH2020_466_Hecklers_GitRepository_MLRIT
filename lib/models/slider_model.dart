class SliderModel {
  String imageAssetPath;
  String title;
  String desc;

  SliderModel({this.imageAssetPath, this.title, this.desc});

  void setImageAssetPath(String getImageAssetPath) {
    imageAssetPath = getImageAssetPath;
  }

  void setTitle(String getTitle) {
    title = getTitle;
  }

  void setDesc(String getDesc) {
    desc = getDesc;
  }

  String getImageAssetPath() {
    return imageAssetPath;
  }

  String getTitle() {
    return title;
  }

  String getDesc() {
    return desc;
  }
}

List<SliderModel> getSlides() {
  List<SliderModel> slides = new List<SliderModel>();
  SliderModel sliderModel = new SliderModel();

  //1
  sliderModel.setDesc(
      "Find Happiness OutDoors. Pack stuff and Go Touring.");
  sliderModel.setTitle("MEMORIES");
  sliderModel.setImageAssetPath("assets/images/illustration.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //2
  sliderModel.setDesc(
      "Make friends create Clans or Go Solo and Explore the world Yourself");
  sliderModel.setTitle("If New Join a Clan");
  sliderModel.setImageAssetPath("assets/images/illustration2.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  //3
  sliderModel.setDesc(
      "Doesn't matter how you go on an Adventure...");
  sliderModel.setTitle("Medium won't Stop YOU");
  sliderModel.setImageAssetPath("assets/images/illustration3.png");
  slides.add(sliderModel);

  sliderModel = new SliderModel();

  return slides;
}
