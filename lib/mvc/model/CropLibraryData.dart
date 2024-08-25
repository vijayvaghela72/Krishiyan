class CropLibraryData {
  NewHarvest? newHarvest;
  PresowingPractices? presowingPractices;
  GeneralInformation? generalInformation;
  String? sId;
  String? localName;
  // List<Null>? cropTypes;
  // List<Null>? states;
  // List<Null>? climate;
  // List<Null>? season;
  // List<Null>? nutrientMgmt;
  // List<Null>? varitiesId;
  List<Faq>? faq;
  List<Stages>? stages;
  // List<Null>? cropStage;
  List<Nutrient>? nutrient;
  // List<Null>? pestMgmt;
  List<Irrigation>? irrigation;
  List<PestManagement>? pestManagement;
  List<DiseaseManagement>? diseaseManagement;
  List<WeedManagement>? weedManagement;
  List<WeatherInjuries>? weatherInjuries;
  // List<Null>? diseaseMgmt;
  String? scientificName;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? iV;

  CropLibraryData(
      {this.newHarvest,
      this.presowingPractices,
      this.generalInformation,
      this.sId,
      this.localName,
      // this.cropTypes,
      // this.states,
      // this.climate,
      // this.season,
      // this.nutrientMgmt,
      // this.varitiesId,
      this.faq,
      this.stages,
      // this.cropStage,
      this.nutrient,
      // this.pestMgmt,
      this.irrigation,
      this.pestManagement,
      this.diseaseManagement,
      this.weedManagement,
      this.weatherInjuries,
      // this.diseaseMgmt,
      this.scientificName,
      this.description,
      this.createdAt,
      this.updatedAt,
      this.iV});

  CropLibraryData.fromJson(Map<String, dynamic> json) {
    newHarvest = json['newHarvest'] != null
        ? NewHarvest.fromJson(json['newHarvest'])
        : null;
    presowingPractices = json['presowingPractices'] != null
        ? PresowingPractices.fromJson(json['presowingPractices'])
        : null;
    generalInformation = json['generalInformation'] != null
        ? GeneralInformation.fromJson(json['generalInformation'])
        : null;
    sId = json['_id'];
    localName = json['localName'];
    if (json['faq'] != null) {
      faq = <Faq>[];
      json['faq'].forEach((v) {
        faq!.add(Faq.fromJson(v));
      });
    }
    if (json['stages'] != null) {
      stages = <Stages>[];
      json['stages'].forEach((v) {
        stages!.add(Stages.fromJson(v));
      });
    }
    if (json['nutrient'] != null) {
      nutrient = <Nutrient>[];
      json['nutrient'].forEach((v) {
        nutrient!.add(Nutrient.fromJson(v));
      });
    }
    if (json['irrigation'] != null) {
      irrigation = <Irrigation>[];
      json['irrigation'].forEach((v) {
        irrigation!.add(Irrigation.fromJson(v));
      });
    }
    if (json['pestManagement'] != null) {
      pestManagement = <PestManagement>[];
      json['pestManagement'].forEach((v) {
        pestManagement!.add(PestManagement.fromJson(v));
      });
    }
    if (json['diseaseManagement'] != null) {
      diseaseManagement = <DiseaseManagement>[];
      json['diseaseManagement'].forEach((v) {
        diseaseManagement!.add(DiseaseManagement.fromJson(v));
      });
    }
    if (json['weedManagement'] != null) {
      weedManagement = <WeedManagement>[];
      json['weedManagement'].forEach((v) {
        weedManagement!.add(WeedManagement.fromJson(v));
      });
    }
    if (json['weatherInjuries'] != null) {
      weatherInjuries = <WeatherInjuries>[];
      json['weatherInjuries'].forEach((v) {
        weatherInjuries!.add(WeatherInjuries.fromJson(v));
      });
    }
    scientificName = json['scientificName'];
    description = json['description'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.newHarvest != null) {
      data['newHarvest'] = this.newHarvest!.toJson();
    }
    if (this.presowingPractices != null) {
      data['presowingPractices'] = this.presowingPractices!.toJson();
    }
    if (this.generalInformation != null) {
      data['generalInformation'] = this.generalInformation!.toJson();
    }
    data['_id'] = this.sId;
    data['localName'] = this.localName;

    if (this.faq != null) {
      data['faq'] = this.faq!.map((v) => v.toJson()).toList();
    }
    if (this.stages != null) {
      data['stages'] = this.stages!.map((v) => v.toJson()).toList();
    }
    if (this.nutrient != null) {
      data['nutrient'] = this.nutrient!.map((v) => v.toJson()).toList();
    }
    if (this.irrigation != null) {
      data['irrigation'] = this.irrigation!.map((v) => v.toJson()).toList();
    }
    if (this.pestManagement != null) {
      data['pestManagement'] =
          this.pestManagement!.map((v) => v.toJson()).toList();
    }
    if (this.diseaseManagement != null) {
      data['diseaseManagement'] =
          this.diseaseManagement!.map((v) => v.toJson()).toList();
    }
    if (this.weedManagement != null) {
      data['weedManagement'] =
          this.weedManagement!.map((v) => v.toJson()).toList();
    }
    if (this.weatherInjuries != null) {
      data['weatherInjuries'] =
          this.weatherInjuries!.map((v) => v.toJson()).toList();
    }
    data['scientificName'] = this.scientificName;
    data['description'] = this.description;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['__v'] = this.iV;
    return data;
  }
}

class NewHarvest {
  List<Null>? images;
  String? maturity;
  String? index;
  String? conditionsDuring;
  String? prevent;
  List<PostHarvest>? postHarvest;

  NewHarvest(
      {this.images,
      this.maturity,
      this.index,
      this.conditionsDuring,
      this.prevent,
      this.postHarvest});

  NewHarvest.fromJson(Map<String, dynamic> json) {
    maturity = json['Maturity'];
    index = json['index'];
    conditionsDuring = json['Conditions_during'];
    prevent = json['prevent'];
    if (json['Post_Harvest'] != null) {
      postHarvest = <PostHarvest>[];
      json['Post_Harvest'].forEach((v) {
        postHarvest!.add(PostHarvest.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Maturity'] = this.maturity;
    data['index'] = this.index;
    data['Conditions_during'] = this.conditionsDuring;
    data['prevent'] = this.prevent;
    if (this.postHarvest != null) {
      data['Post_Harvest'] = this.postHarvest!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PostHarvest {
  String? losses;
  List<String>? images;
  String? sId;

  PostHarvest({this.losses, this.images, this.sId});

  PostHarvest.fromJson(Map<String, dynamic> json) {
    losses = json['losses'];
    images = json['images'].cast<String>();
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['losses'] = this.losses;
    data['images'] = this.images;
    data['_id'] = this.sId;
    return data;
  }
}

class PresowingPractices {
  SeedTreatment? seedTreatment;
  String? landPreparation;
  List<String>? interculturalOperations;
  String? soilConditions;

  PresowingPractices(
      {this.seedTreatment,
      this.landPreparation,
      this.interculturalOperations,
      this.soilConditions});

  PresowingPractices.fromJson(Map<String, dynamic> json) {
    seedTreatment = json['Seed_treatment'] != null
        ? SeedTreatment.fromJson(json['Seed_treatment'])
        : null;
    landPreparation = json['Land_Preparation'];
    interculturalOperations = json['Intercultural_Operations'].cast<String>();
    soilConditions = json['Soil_Conditions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.seedTreatment != null) {
      data['Seed_treatment'] = this.seedTreatment!.toJson();
    }
    data['Land_Preparation'] = this.landPreparation;
    data['Intercultural_Operations'] = this.interculturalOperations;
    data['Soil_Conditions'] = this.soilConditions;
    return data;
  }
}

class SeedTreatment {
  String? nameOfChemical;
  String? dosage;

  SeedTreatment({this.nameOfChemical, this.dosage});

  SeedTreatment.fromJson(Map<String, dynamic> json) {
    nameOfChemical = json['nameOfChemical'];
    dosage = json['Dosage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['nameOfChemical'] = this.nameOfChemical;
    data['Dosage'] = this.dosage;
    return data;
  }
}

class GeneralInformation {
  String? kharif;
  String? rabi;
  String? zaid;
  String? optimumTemperature;
  String? rainfallRequirement;
  String? recommendedSoil;
  String? pHSoil;
  String? spacing;
  String? seedRate;
  String? averageYield;
  String? intercrop;

  GeneralInformation(
      {this.kharif,
      this.rabi,
      this.zaid,
      this.optimumTemperature,
      this.rainfallRequirement,
      this.recommendedSoil,
      this.pHSoil,
      this.spacing,
      this.seedRate,
      this.averageYield,
      this.intercrop});

  GeneralInformation.fromJson(Map<String, dynamic> json) {
    kharif = json['Kharif'];
    rabi = json['Rabi'];
    zaid = json['Zaid'];
    optimumTemperature = json['Optimum_temperature'];
    rainfallRequirement = json['Rainfall_requirement'];
    recommendedSoil = json['Recommended_soil'];
    pHSoil = json['pH_soil'];
    spacing = json['Spacing'];
    seedRate = json['Seed_rate'];
    averageYield = json['Average_yield'];
    intercrop = json['Intercrop'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Kharif'] = this.kharif;
    data['Rabi'] = this.rabi;
    data['Zaid'] = this.zaid;
    data['Optimum_temperature'] = this.optimumTemperature;
    data['Rainfall_requirement'] = this.rainfallRequirement;
    data['Recommended_soil'] = this.recommendedSoil;
    data['pH_soil'] = this.pHSoil;
    data['Spacing'] = this.spacing;
    data['Seed_rate'] = this.seedRate;
    data['Average_yield'] = this.averageYield;
    data['Intercrop'] = this.intercrop;
    return data;
  }
}

class Faq {
  String? question;
  String? answer;
  String? sId;

  Faq({this.question, this.answer, this.sId});

  Faq.fromJson(Map<String, dynamic> json) {
    question = json['question'];
    answer = json['answer'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['question'] = this.question;
    data['answer'] = this.answer;
    data['_id'] = this.sId;
    return data;
  }
}

class Stages {
  int? sn;
  String? name;
  List<String>? images;
  List<Null>? disease;
  List<Null>? pest;
  List<Null>? weed;
  String? interculturalOperation;
  String? sId;

  Stages(
      {this.sn,
      this.name,
      this.images,
      this.disease,
      this.pest,
      this.weed,
      this.interculturalOperation,
      this.sId});

  Stages.fromJson(Map<String, dynamic> json) {
    sn = json['sn'];
    name = json['name'];
    images = json['images'].cast<String>();
    interculturalOperation = json['interculturalOperation'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sn'] = this.sn;
    data['name'] = this.name;
    data['images'] = this.images;
    data['interculturalOperation'] = this.interculturalOperation;
    data['_id'] = this.sId;
    return data;
  }
}

class Nutrient {
  Deficiency? deficiency;
  String? name;
  String? dosage;
  String? age;
  String? methodApplication;
  String? sId;
  String? role;

  Nutrient(
      {this.deficiency,
      this.name,
      this.dosage,
      this.age,
      this.methodApplication,
      this.sId,
      this.role});

  Nutrient.fromJson(Map<String, dynamic> json) {
    deficiency = json['deficiency'] != null
        ? Deficiency.fromJson(json['deficiency'])
        : null;
    name = json['name'];
    dosage = json['Dosage'];
    age = json['age'];
    methodApplication = json['Method_application'];
    sId = json['_id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.deficiency != null) {
      data['deficiency'] = this.deficiency!.toJson();
    }
    data['name'] = this.name;
    data['Dosage'] = this.dosage;
    data['age'] = this.age;
    data['Method_application'] = this.methodApplication;
    data['_id'] = this.sId;
    data['role'] = this.role;
    return data;
  }
}

class Deficiency {
  String? notableSymptoms;
  List<String>? images;
  String? solution;

  Deficiency({this.notableSymptoms, this.images, this.solution});

  Deficiency.fromJson(Map<String, dynamic> json) {
    notableSymptoms = json['Notable_Symptoms'];
    images = json['images'].cast<String>();
    solution = json['Solution'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['Notable_Symptoms'] = this.notableSymptoms;
    data['images'] = this.images;
    data['Solution'] = this.solution;
    return data;
  }
}

class Irrigation {
  String? criticalStage;
  String? age;
  String? methodology;
  String? operations;
  String? sId;

  Irrigation(
      {this.criticalStage,
      this.age,
      this.methodology,
      this.operations,
      this.sId});

  Irrigation.fromJson(Map<String, dynamic> json) {
    criticalStage = json['criticalStage'];
    age = json['age'];
    methodology = json['methodology'];
    operations = json['operations'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['criticalStage'] = this.criticalStage;
    data['age'] = this.age;
    data['methodology'] = this.methodology;
    data['operations'] = this.operations;
    data['_id'] = this.sId;
    return data;
  }
}

class PestManagement {
  String? name;
  List<String>? images;
  String? solutions;
  String? sId;

  PestManagement({this.name, this.images, this.solutions, this.sId});

  PestManagement.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    images = json['images'].cast<String>();
    solutions = json['solutions'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['images'] = this.images;
    data['solutions'] = this.solutions;
    data['_id'] = this.sId;
    return data;
  }
}

class DiseaseManagement {
  String? name;
  String? causal;
  String? symptoms;
  List<String>? images;
  String? solutions;
  String? sId;

  DiseaseManagement(
      {this.name,
      this.causal,
      this.symptoms,
      this.images,
      this.solutions,
      this.sId});

  DiseaseManagement.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    causal = json['causal'];
    symptoms = json['symptoms'];
    images = json['images'].cast<String>();
    solutions = json['solutions'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['name'] = this.name;
    data['causal'] = this.causal;
    data['symptoms'] = this.symptoms;
    data['images'] = this.images;
    data['solutions'] = this.solutions;
    data['_id'] = this.sId;
    return data;
  }
}

class WeedManagement {
  String? category;
  String? name;
  String? image;
  String? solutions;
  String? sId;

  WeedManagement(
      {this.category, this.name, this.image, this.solutions, this.sId});

  WeedManagement.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    name = json['name'];
    image = json['image'];
    solutions = json['solutions'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['category'] = this.category;
    data['name'] = this.name;
    data['image'] = this.image;
    data['solutions'] = this.solutions;
    data['_id'] = this.sId;
    return data;
  }
}

class WeatherInjuries {
  String? causes;
  String? symptoms;
  String? image;
  String? sId;

  WeatherInjuries({this.causes, this.symptoms, this.image, this.sId});

  WeatherInjuries.fromJson(Map<String, dynamic> json) {
    causes = json['causes'];
    symptoms = json['symptoms'];
    image = json['image'];
    sId = json['_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['causes'] = this.causes;
    data['symptoms'] = this.symptoms;
    data['image'] = this.image;
    data['_id'] = this.sId;
    return data;
  }
}
