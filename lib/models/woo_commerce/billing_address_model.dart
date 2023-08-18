class BillingAddressModel {
    String? address_1;
    String? address_2;
    String? city;
    String? company;
    String? country;
    String? email;
    String? firstName;
    String? lastName;
    String? phone;
    String? postcode;
    String? state;

    BillingAddressModel({this.address_1, this.address_2, this.city, this.company, this.country, this.email, this.firstName, this.lastName, this.phone, this.postcode, this.state});

    factory BillingAddressModel.fromJson(Map<String, dynamic> json) {
        return BillingAddressModel(
            address_1: json['address_1'], 
            address_2: json['address_2'], 
            city: json['city'], 
            company: json['company'], 
            country: json['country'], 
            email: json['email'], 
            firstName: json['first_name'], 
            lastName: json['last_name'], 
            phone: json['phone'], 
            postcode: json['postcode'], 
            state: json['state'], 
        );
    }

    Map<String, dynamic> toJson() {
        final Map<String, dynamic> data = new Map<String, dynamic>();
        data['address_1'] = this.address_1;
        data['address_2'] = this.address_2;
        data['city'] = this.city;
        data['company'] = this.company;
        data['country'] = this.country;
        data['email'] = this.email;
        data['first_name'] = this.firstName;
        data['last_name'] = this.lastName;
        data['phone'] = this.phone;
        data['postcode'] = this.postcode;
        data['state'] = this.state;
        return data;
    }
}