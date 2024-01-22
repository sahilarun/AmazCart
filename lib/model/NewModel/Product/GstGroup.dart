class GstGroup {
    GstGroup({
        this.id,
        this.name,
        this.sameStateGst,
        this.outsiteStateGst,
    });

    int? id;
    String? name;
    String? sameStateGst;
    String? outsiteStateGst;

    factory GstGroup.fromJson(Map<String, dynamic> json) => GstGroup(
        id: json["id"],
        name: json["name"],
        sameStateGst: json["same_state_gst"],
        outsiteStateGst: json["outsite_state_gst"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "same_state_gst": sameStateGst,
        "outsite_state_gst": outsiteStateGst,
    };
}