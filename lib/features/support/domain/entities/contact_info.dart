import 'package:equatable/equatable.dart';

/// Información de contacto de la tienda.
class ContactInfo extends Equatable {
  const ContactInfo({
    required this.email,
    required this.phone,
    required this.address,
    this.socialMedia = const {},
  });

  final String email;
  final String phone;
  final String address;
  final Map<String, String> socialMedia;

  @override
  List<Object?> get props => [email, phone, address, socialMedia];
}

