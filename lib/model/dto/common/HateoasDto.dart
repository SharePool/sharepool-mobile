class HateoasDto<T> {
  T dto;
  String link;

  HateoasDto(this.dto, this.link);

  static HateoasDto<T> create<T>(
      DtoFromJsonFunction<T> func, Map<String, dynamic> json) {
    return new HateoasDto(func(), getRelLinkFromJson("self", json));
  }

  static String getRelLinkFromJson(String relName, Map<String, dynamic> json) {
    return json["_links"][relName]["href"];
  }
}

typedef DtoFromJsonFunction<T> = T Function();
