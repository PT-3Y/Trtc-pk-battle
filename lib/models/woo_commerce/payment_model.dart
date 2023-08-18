class PaymentModel {
  String? connectionUrl;
  String? description;
  bool? enabled;
  String? id;
  String? methodDescription;
  List<String>? methodSupports;
  String? methodTitle;
  bool? needsSetup;
  //num? order;
  Settings? settings;
  String? settingsUrl;
  String? title;

  PaymentModel({
    this.connectionUrl,
    this.description,
    this.enabled,
    this.id,
    this.methodDescription,
    this.methodSupports,
    this.methodTitle,
    this.needsSetup,
    //this.order,
    this.settings,
    this.settingsUrl,
    this.title,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      connectionUrl: json['connection_url'],
      description: json['description'],
      enabled: json['enabled'],
      id: json['id'],
      methodDescription: json['method_description'],
      methodSupports: json['method_supports'] != null ? new List<String>.from(json['method_supports']) : null,
      methodTitle: json['method_title'],
      needsSetup: json['needs_setup'],
      //order: json['order'],
      settings: json['settings'] != null ? Settings.fromJson(json['settings']) : null,
      settingsUrl: json['settings_url'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['enabled'] = this.enabled;
    data['id'] = this.id;
    data['method_description'] = this.methodDescription;
    data['method_title'] = this.methodTitle;
    data['needs_setup'] = this.needsSetup;
    //data['order'] = this.order;
    data['settings_url'] = this.settingsUrl;
    data['title'] = this.title;

    if (this.connectionUrl != null) {
      data['connection_url'] = this.connectionUrl;
    }
    if (this.methodSupports != null) {
      data['method_supports'] = this.methodSupports;
    }

    if (this.settings != null) {
      data['settings'] = this.settings!.toJson();
    }

    return data;
  }
}

class Settings {
  EnableForMethods? enableForMethods;
  EnableForVirtual? enableForVirtual;
  Instructions? instructions;
  Title? title;

  Settings({this.enableForMethods, this.enableForVirtual, this.instructions, this.title});

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      enableForMethods: json['enable_for_methods'] != null ? EnableForMethods.fromJson(json['enable_for_methods']) : null,
      enableForVirtual: json['enable_for_virtual'] != null ? EnableForVirtual.fromJson(json['enable_for_virtual']) : null,
      instructions: json['instructions'] != null ? Instructions.fromJson(json['instructions']) : null,
      title: json['title'] != null ? Title.fromJson(json['title']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.enableForMethods != null) {
      data['enable_for_methods'] = this.enableForMethods!.toJson();
    }
    if (this.enableForVirtual != null) {
      data['enable_for_virtual'] = this.enableForVirtual!.toJson();
    }
    if (this.instructions != null) {
      data['instructions'] = this.instructions!.toJson();
    }
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    return data;
  }
}

class Instructions {
  String? defaultValue;
  String? description;
  String? id;
  String? label;
  String? placeholder;
  String? tip;
  String? type;
  String? value;

  Instructions({this.defaultValue, this.description, this.id, this.label, this.placeholder, this.tip, this.type, this.value});

  factory Instructions.fromJson(Map<String, dynamic> json) {
    return Instructions(
      defaultValue: json['default'],
      description: json['description'],
      id: json['id'],
      label: json['label'],
      placeholder: json['placeholder'],
      tip: json['tip'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default'] = this.defaultValue;
    data['description'] = this.description;
    data['id'] = this.id;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['tip'] = this.tip;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class EnableForMethods {
  String? defaultValue;
  String? description;
  String? id;
  String? label;
  Options? options;
  String? placeholder;
  String? tip;
  String? type;
  String? value;

  EnableForMethods({this.defaultValue, this.description, this.id, this.label, this.options, this.placeholder, this.tip, this.type, this.value});

  factory EnableForMethods.fromJson(Map<String, dynamic> json) {
    return EnableForMethods(
      defaultValue: json['default'],
      description: json['description'],
      id: json['id'],
      label: json['label'],
      options: json['options'] != null ? Options.fromJson(json['options']) : null,
      placeholder: json['placeholder'],
      tip: json['tip'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default'] = this.defaultValue;
    data['description'] = this.description;
    data['id'] = this.id;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['tip'] = this.tip;
    data['type'] = this.type;
    data['value'] = this.value;
    if (this.options != null) {
      data['options'] = this.options!.toJson();
    }
    return data;
  }
}

class Options {
  LocalPickup? pickup;
  FlatRate? rate;
  FreeShipping? shipping;

  Options({this.pickup, this.rate, this.shipping});

  factory Options.fromJson(Map<String, dynamic> json) {
    return Options(
      pickup: json['pickup'] != null ? LocalPickup.fromJson(json['pickup']) : null,
      rate: json['rate'] != null ? FlatRate.fromJson(json['rate']) : null,
      shipping: json['shipping'] != null ? FreeShipping.fromJson(json['shipping']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pickup != null) {
      data['pickup'] = this.pickup!.toJson();
    }
    if (this.rate != null) {
      data['rate'] = this.rate!.toJson();
    }
    if (this.shipping != null) {
      data['shipping'] = this.shipping!.toJson();
    }
    return data;
  }
}

class FlatRate {
  String? flat_rate;

  FlatRate({this.flat_rate});

  factory FlatRate.fromJson(Map<String, dynamic> json) {
    return FlatRate(
      flat_rate: json['flat_rate'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flat_rate'] = this.flat_rate;
    return data;
  }
}

class FreeShipping {
  String? freeShipping;

  FreeShipping({this.freeShipping});

  factory FreeShipping.fromJson(Map<String, dynamic> json) {
    return FreeShipping(
      freeShipping: json['free_shipping'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['free_shipping'] = this.freeShipping;
    return data;
  }
}

class LocalPickup {
  String? localPickup;

  LocalPickup({this.localPickup});

  factory LocalPickup.fromJson(Map<String, dynamic> json) {
    return LocalPickup(
      localPickup: json['local_pickup'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['local_pickup'] = this.localPickup;
    return data;
  }
}

class EnableForVirtual {
  String? defaultValue;
  String? description;
  String? id;
  String? label;
  String? placeholder;
  String? tip;
  String? type;
  String? value;

  EnableForVirtual({this.defaultValue, this.description, this.id, this.label, this.placeholder, this.tip, this.type, this.value});

  factory EnableForVirtual.fromJson(Map<String, dynamic> json) {
    return EnableForVirtual(
      defaultValue: json['default'],
      description: json['description'],
      id: json['id'],
      label: json['label'],
      placeholder: json['placeholder'],
      tip: json['tip'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default'] = this.defaultValue;
    data['description'] = this.description;
    data['id'] = this.id;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['tip'] = this.tip;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}

class Title {
  String? defaultValue;
  String? description;
  String? id;
  String? label;
  String? placeholder;
  String? tip;
  String? type;
  String? value;

  Title({this.defaultValue, this.description, this.id, this.label, this.placeholder, this.tip, this.type, this.value});

  factory Title.fromJson(Map<String, dynamic> json) {
    return Title(
      defaultValue: json['default'],
      description: json['description'],
      id: json['id'],
      label: json['label'],
      placeholder: json['placeholder'],
      tip: json['tip'],
      type: json['type'],
      value: json['value'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['default'] = this.defaultValue;
    data['description'] = this.description;
    data['id'] = this.id;
    data['label'] = this.label;
    data['placeholder'] = this.placeholder;
    data['tip'] = this.tip;
    data['type'] = this.type;
    data['value'] = this.value;
    return data;
  }
}
