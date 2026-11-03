import 'package:flutter/material.dart';

import '../../models/loan_product_model.dart';
import '../../models/option_model.dart';
import '../config/theme/app_colors.dart';
import 'app_images.dart';

/// Static catalogue data (would come from an API in production).
class AppData {
  AppData._();

  static const List<LoanProductModel> products = [
    LoanProductModel(
      id: 'home',
      title: 'Home Loan',
      subtitle: 'Buy or build your dream home',
      icon: Icons.house_rounded,
      color: AppColors.green,
      rate: 6.90,
      maxAmount: '₹5 Crore',
      maxTenure: 30,
    ),
    LoanProductModel(
      id: 'lap',
      title: 'Loan Against Property',
      subtitle: 'Unlock the value of your property',
      icon: Icons.home_work_rounded,
      color: AppColors.orange,
      rate: 8.50,
      maxAmount: '₹10 Crore',
      maxTenure: 15,
    ),
    LoanProductModel(
      id: 'auto',
      title: 'Auto Loan',
      subtitle: 'Drive your dream vehicle',
      icon: Icons.directions_car_filled_rounded,
      color: AppColors.violet,
      rate: 8.75,
      maxAmount: '₹1 Crore',
      maxTenure: 7,
    ),
    LoanProductModel(
      id: 'personal',
      title: 'Personal Loan',
      subtitle: 'For your immediate financial needs',
      icon: Icons.person_rounded,
      color: AppColors.blue,
      rate: 10.50,
      maxAmount: '₹40 Lakh',
      maxTenure: 5,
    ),
    LoanProductModel(
      id: 'business',
      title: 'Business Loan',
      subtitle: 'Grow your business with ease',
      icon: Icons.business_center_rounded,
      color: AppColors.orange,
      rate: 11.00,
      maxAmount: '₹2 Crore',
      maxTenure: 10,
    ),
  ];

  static LoanProductModel product(String id) =>
      products.firstWhere((p) => p.id == id, orElse: () => products.first);

  static const genders = [
    OptionModel(id: 'male', title: 'Male', image: AppImages.genderMale),
    OptionModel(id: 'female', title: 'Female', image: AppImages.genderFemale),
  ];

  static const cities = [
    OptionModel(id: 'delhi', title: 'New Delhi', image: AppImages.cityDelhi),
    OptionModel(id: 'mumbai', title: 'Mumbai', image: AppImages.cityMumbai),
    OptionModel(id: 'pune', title: 'Pune', image: AppImages.cityPune),
    OptionModel(
      id: 'bangalore',
      title: 'Bangalore',
      image: AppImages.cityBangalore,
    ),
    OptionModel(id: 'others', title: 'Others', image: AppImages.cityOthers),
  ];

  static const purposes = [
    OptionModel(
      id: 'residential',
      title: 'Residential Home Loan',
      image: AppImages.purposeResidential,
    ),
    OptionModel(
      id: 'commercial',
      title: 'Commercial/ Project Loan',
      image: AppImages.purposeCommercial,
    ),
    OptionModel(
      id: 'transfer',
      title: 'Transfer My Existing Loan',
      image: AppImages.purposeTransfer,
    ),
  ];

  static const employmentTypes = [
    OptionModel(
      id: 'salaried',
      title: 'Salaried',
      image: AppImages.empSalaried,
    ),
    OptionModel(
      id: 'business',
      title: 'Self Employed Business',
      image: AppImages.empBusiness,
    ),
    OptionModel(
      id: 'professional',
      title: 'Self Employed Professional',
      image: AppImages.empProfessional,
    ),
  ];

  static String titleOf(List<OptionModel> list, String id) {
    for (final o in list) {
      if (o.id == id) return o.title;
    }
    return id;
  }
}
