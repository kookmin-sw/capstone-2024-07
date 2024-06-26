package com.dclass.backend.domain.department

import com.dclass.backend.domain.department.DepartmentDetail.Accounting
import com.dclass.backend.domain.department.DepartmentDetail.AdvertisingDesign
import com.dclass.backend.domain.department.DepartmentDetail.AdvertisingPublicRelations
import com.dclass.backend.domain.department.DepartmentDetail.AerospaceEngineering
import com.dclass.backend.domain.department.DepartmentDetail.AgriculturalEducation
import com.dclass.backend.domain.department.DepartmentDetail.AgricultureFisheries
import com.dclass.backend.domain.department.DepartmentDetail.Animation
import com.dclass.backend.domain.department.DepartmentDetail.AppliedArts
import com.dclass.backend.domain.department.DepartmentDetail.AquaticMarineIndustryEducation
import com.dclass.backend.domain.department.DepartmentDetail.Architecture
import com.dclass.backend.domain.department.DepartmentDetail.ArtEducation
import com.dclass.backend.domain.department.DepartmentDetail.ArtTherapy
import com.dclass.backend.domain.department.DepartmentDetail.Astronomy
import com.dclass.backend.domain.department.DepartmentDetail.AutomotiveEngineering
import com.dclass.backend.domain.department.DepartmentDetail.BiologyEducation
import com.dclass.backend.domain.department.DepartmentDetail.BuddhistStudies
import com.dclass.backend.domain.department.DepartmentDetail.BusinessAdministration
import com.dclass.backend.domain.department.DepartmentDetail.CeramicEngineering
import com.dclass.backend.domain.department.DepartmentDetail.ChemicalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Chemistry
import com.dclass.backend.domain.department.DepartmentDetail.ChemistryEducation
import com.dclass.backend.domain.department.DepartmentDetail.ChildEducation
import com.dclass.backend.domain.department.DepartmentDetail.ChildFamilyStudies
import com.dclass.backend.domain.department.DepartmentDetail.ChineseLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.CivilEngineering
import com.dclass.backend.domain.department.DepartmentDetail.ClassicalChinese
import com.dclass.backend.domain.department.DepartmentDetail.ClassicalChineseEducation
import com.dclass.backend.domain.department.DepartmentDetail.ClinicalPathology
import com.dclass.backend.domain.department.DepartmentDetail.Clothing
import com.dclass.backend.domain.department.DepartmentDetail.CommercialDiving
import com.dclass.backend.domain.department.DepartmentDetail.ComputerEducation
import com.dclass.backend.domain.department.DepartmentDetail.ComputerScience
import com.dclass.backend.domain.department.DepartmentDetail.ConstructionEngineeringEducation
import com.dclass.backend.domain.department.DepartmentDetail.ConsumerStudies
import com.dclass.backend.domain.department.DepartmentDetail.ControlMeasurementEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Cosmetics
import com.dclass.backend.domain.department.DepartmentDetail.Crafts
import com.dclass.backend.domain.department.DepartmentDetail.CreativeWriting
import com.dclass.backend.domain.department.DepartmentDetail.CulinaryArts
import com.dclass.backend.domain.department.DepartmentDetail.CulturalAnthropology
import com.dclass.backend.domain.department.DepartmentDetail.DanceSports
import com.dclass.backend.domain.department.DepartmentDetail.DefenseTechnology
import com.dclass.backend.domain.department.DepartmentDetail.Dentistry
import com.dclass.backend.domain.department.DepartmentDetail.DramaFilm
import com.dclass.backend.domain.department.DepartmentDetail.EarthMarineScience
import com.dclass.backend.domain.department.DepartmentDetail.EarthScienceEducation
import com.dclass.backend.domain.department.DepartmentDetail.Economics
import com.dclass.backend.domain.department.DepartmentDetail.ElectricalElectronicsTelecommunicationEngineeringEducation
import com.dclass.backend.domain.department.DepartmentDetail.ElectricalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.ElectronicsEngineering
import com.dclass.backend.domain.department.DepartmentDetail.ElementaryEducation
import com.dclass.backend.domain.department.DepartmentDetail.EmergencyMedicalTechnology
import com.dclass.backend.domain.department.DepartmentDetail.EnergyResourcesEngineering
import com.dclass.backend.domain.department.DepartmentDetail.EnglishLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.EnvironmentalChemistry
import com.dclass.backend.domain.department.DepartmentDetail.EnvironmentalEducation
import com.dclass.backend.domain.department.DepartmentDetail.EnvironmentalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.EnvironmentalHealth
import com.dclass.backend.domain.department.DepartmentDetail.EthicsEducation
import com.dclass.backend.domain.department.DepartmentDetail.FashionDesign
import com.dclass.backend.domain.department.DepartmentDetail.Finance
import com.dclass.backend.domain.department.DepartmentDetail.FineArts
import com.dclass.backend.domain.department.DepartmentDetail.FireProtection
import com.dclass.backend.domain.department.DepartmentDetail.FireSafetyManagement
import com.dclass.backend.domain.department.DepartmentDetail.FoodScience
import com.dclass.backend.domain.department.DepartmentDetail.ForestEngineering
import com.dclass.backend.domain.department.DepartmentDetail.FrenchLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.GameEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Gemology
import com.dclass.backend.domain.department.DepartmentDetail.Geography
import com.dclass.backend.domain.department.DepartmentDetail.Geography2
import com.dclass.backend.domain.department.DepartmentDetail.GeographyEducation
import com.dclass.backend.domain.department.DepartmentDetail.Geology
import com.dclass.backend.domain.department.DepartmentDetail.GermanLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.GraphicDesign
import com.dclass.backend.domain.department.DepartmentDetail.HealthCare
import com.dclass.backend.domain.department.DepartmentDetail.History
import com.dclass.backend.domain.department.DepartmentDetail.HistoryEducation
import com.dclass.backend.domain.department.DepartmentDetail.HomeEducation
import com.dclass.backend.domain.department.DepartmentDetail.Horticulture
import com.dclass.backend.domain.department.DepartmentDetail.HotelManagement
import com.dclass.backend.domain.department.DepartmentDetail.IndependentMajor
import com.dclass.backend.domain.department.DepartmentDetail.IndustrialDesign
import com.dclass.backend.domain.department.DepartmentDetail.IndustrialEngineering
import com.dclass.backend.domain.department.DepartmentDetail.IndustrialFacilityAutomation
import com.dclass.backend.domain.department.DepartmentDetail.InformationSecurity
import com.dclass.backend.domain.department.DepartmentDetail.InstrumentalMusic
import com.dclass.backend.domain.department.DepartmentDetail.InteriorDesign
import com.dclass.backend.domain.department.DepartmentDetail.InternationalStudies
import com.dclass.backend.domain.department.DepartmentDetail.InternationalTrade
import com.dclass.backend.domain.department.DepartmentDetail.JapaneseLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.KoreanLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.KoreanMedicine
import com.dclass.backend.domain.department.DepartmentDetail.LandscapeArchitecture
import com.dclass.backend.domain.department.DepartmentDetail.LanguageEducation
import com.dclass.backend.domain.department.DepartmentDetail.LanguageInformatics
import com.dclass.backend.domain.department.DepartmentDetail.Law
import com.dclass.backend.domain.department.DepartmentDetail.LibraryInformationScience
import com.dclass.backend.domain.department.DepartmentDetail.LifeSciences
import com.dclass.backend.domain.department.DepartmentDetail.Logistics
import com.dclass.backend.domain.department.DepartmentDetail.LogisticsSystemsEngineering
import com.dclass.backend.domain.department.DepartmentDetail.MakeupArtistry
import com.dclass.backend.domain.department.DepartmentDetail.ManagementInformationSystems
import com.dclass.backend.domain.department.DepartmentDetail.MarineEngineering
import com.dclass.backend.domain.department.DepartmentDetail.MaterialsEngineering
import com.dclass.backend.domain.department.DepartmentDetail.MaterialsEngineeringEducation
import com.dclass.backend.domain.department.DepartmentDetail.Mathematics
import com.dclass.backend.domain.department.DepartmentDetail.MathematicsEducation
import com.dclass.backend.domain.department.DepartmentDetail.MechanicalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.MediaCommunication
import com.dclass.backend.domain.department.DepartmentDetail.MediaFilmStudies
import com.dclass.backend.domain.department.DepartmentDetail.MediaPublishing
import com.dclass.backend.domain.department.DepartmentDetail.MedicalAdministration
import com.dclass.backend.domain.department.DepartmentDetail.MedicalEquipmentEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Medicine
import com.dclass.backend.domain.department.DepartmentDetail.MetallurgicalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.MilitaryScience
import com.dclass.backend.domain.department.DepartmentDetail.Modeling
import com.dclass.backend.domain.department.DepartmentDetail.MoldDesign
import com.dclass.backend.domain.department.DepartmentDetail.MultimediaStudies
import com.dclass.backend.domain.department.DepartmentDetail.Music
import com.dclass.backend.domain.department.DepartmentDetail.MusicEducation
import com.dclass.backend.domain.department.DepartmentDetail.NOT_SELECTED
import com.dclass.backend.domain.department.DepartmentDetail.NanoEngineering
import com.dclass.backend.domain.department.DepartmentDetail.NewMaterialsEngineering
import com.dclass.backend.domain.department.DepartmentDetail.NorthKoreanStudies
import com.dclass.backend.domain.department.DepartmentDetail.NuclearEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Nursing
import com.dclass.backend.domain.department.DepartmentDetail.OpticalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.PaperEngineering
import com.dclass.backend.domain.department.DepartmentDetail.PharmaceuticalEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Pharmacy
import com.dclass.backend.domain.department.DepartmentDetail.Philosophy
import com.dclass.backend.domain.department.DepartmentDetail.PhysicalEducation
import com.dclass.backend.domain.department.DepartmentDetail.PhysicalTherapy
import com.dclass.backend.domain.department.DepartmentDetail.Physics
import com.dclass.backend.domain.department.DepartmentDetail.PhysicsEducation
import com.dclass.backend.domain.department.DepartmentDetail.PoliceAdministration
import com.dclass.backend.domain.department.DepartmentDetail.PoliticalDiplomacy
import com.dclass.backend.domain.department.DepartmentDetail.PolymerEngineering
import com.dclass.backend.domain.department.DepartmentDetail.PracticalMusic
import com.dclass.backend.domain.department.DepartmentDetail.Psychology
import com.dclass.backend.domain.department.DepartmentDetail.PublicAdministration
import com.dclass.backend.domain.department.DepartmentDetail.Radiology
import com.dclass.backend.domain.department.DepartmentDetail.RailwayTransportation
import com.dclass.backend.domain.department.DepartmentDetail.RefrigerationAirConditioningEngineering
import com.dclass.backend.domain.department.DepartmentDetail.ReligiousEducation
import com.dclass.backend.domain.department.DepartmentDetail.RenewableEnergy
import com.dclass.backend.domain.department.DepartmentDetail.RoboticsEngineering
import com.dclass.backend.domain.department.DepartmentDetail.RussianLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.SafetyEngineering
import com.dclass.backend.domain.department.DepartmentDetail.ScienceEducation
import com.dclass.backend.domain.department.DepartmentDetail.Sculpture
import com.dclass.backend.domain.department.DepartmentDetail.SecurityStudies
import com.dclass.backend.domain.department.DepartmentDetail.SemiconductorStudies
import com.dclass.backend.domain.department.DepartmentDetail.ShipbuildingEngineering
import com.dclass.backend.domain.department.DepartmentDetail.SocialEducation
import com.dclass.backend.domain.department.DepartmentDetail.SocialSports
import com.dclass.backend.domain.department.DepartmentDetail.SocialWelfare
import com.dclass.backend.domain.department.DepartmentDetail.Sociology
import com.dclass.backend.domain.department.DepartmentDetail.SpanishLanguageLiterature
import com.dclass.backend.domain.department.DepartmentDetail.SpecialEducation
import com.dclass.backend.domain.department.DepartmentDetail.SpecialEquipment
import com.dclass.backend.domain.department.DepartmentDetail.SpeechRehabilitation
import com.dclass.backend.domain.department.DepartmentDetail.SpeechTherapy
import com.dclass.backend.domain.department.DepartmentDetail.SurveyingInformation
import com.dclass.backend.domain.department.DepartmentDetail.SystemsEngineering
import com.dclass.backend.domain.department.DepartmentDetail.Taxation
import com.dclass.backend.domain.department.DepartmentDetail.TechnologyEducation
import com.dclass.backend.domain.department.DepartmentDetail.TextileStudies
import com.dclass.backend.domain.department.DepartmentDetail.Theology
import com.dclass.backend.domain.department.DepartmentDetail.Tourism
import com.dclass.backend.domain.department.DepartmentDetail.Trade
import com.dclass.backend.domain.department.DepartmentDetail.TrafficEngineering
import com.dclass.backend.domain.department.DepartmentDetail.UnmannedAviation
import com.dclass.backend.domain.department.DepartmentDetail.UrbanEngineering
import com.dclass.backend.domain.department.DepartmentDetail.UrbanStudies
import com.dclass.backend.domain.department.DepartmentDetail.VeterinaryMedicine
import com.dclass.backend.domain.department.DepartmentDetail.VocalMusic
import com.dclass.backend.domain.department.DepartmentDetail.Zoology

enum class DepartmentGroup(
    val category: String,
    val departments: List<DepartmentDetail>,
) {
    HUMANITIES(
        "인문계열",
        listOf(
            LanguageInformatics,
            KoreanLanguageLiterature,
            GermanLanguageLiterature,
            RussianLanguageLiterature,
            EnglishLanguageLiterature,
            JapaneseLanguageLiterature,
            ChineseLanguageLiterature,
            FrenchLanguageLiterature,
            SpanishLanguageLiterature,
            NorthKoreanStudies,
            Philosophy,
            History,
            CulturalAnthropology,
            CreativeWriting,
            LibraryInformationScience,
            Tourism,
            ClassicalChinese,
            Theology,
            BuddhistStudies,
            IndependentMajor,
        ),
    ),
    SOCIAL_SCIENCES(
        "사회과학계열",
        listOf(
            BusinessAdministration,
            Economics,
            ManagementInformationSystems,
            InternationalTrade,
            AdvertisingPublicRelations,
            Finance,
            Accounting,
            Taxation,
            Psychology,
            Law,
            Sociology,
            UrbanStudies,
            PoliticalDiplomacy,
            InternationalStudies,
            SocialWelfare,
            MediaCommunication,
            Geography,
            PublicAdministration,
            MilitaryScience,
            PoliceAdministration,
            ChildFamilyStudies,
            ConsumerStudies,
            Logistics,
            Trade,
            HotelManagement,
        ),
    ),
    EDUCATION(
        "교육계열",
        listOf(
            HomeEducation,
            ConstructionEngineeringEducation,
            ScienceEducation,
            ElectricalElectronicsTelecommunicationEngineeringEducation,
            MaterialsEngineeringEducation,
            TechnologyEducation,
            AgriculturalEducation,
            PhysicsEducation,
            ArtEducation,
            SocialEducation,
            BiologyEducation,
            MathematicsEducation,
            AquaticMarineIndustryEducation,
            ChildEducation,
            SpeechTherapy,
            LanguageEducation,
            HistoryEducation,
            MusicEducation,
            EthicsEducation,
            ReligiousEducation,
            EarthScienceEducation,
            GeographyEducation,
            PhysicalEducation,
            ElementaryEducation,
            ComputerEducation,
            SpecialEducation,
            ClassicalChineseEducation,
            ChemistryEducation,
            EnvironmentalEducation,
        ),
    ),
    ENGINEERING(
        "공학계열",
        listOf(
            ComputerScience,
            ShipbuildingEngineering,
            IndustrialEngineering,
            MultimediaStudies,
            GameEngineering,
            MediaPublishing,
            MaterialsEngineering,
            Cosmetics,
            Architecture,
            LogisticsSystemsEngineering,
            MarineEngineering,
            PolymerEngineering,
            OpticalEngineering,
            TrafficEngineering,
            DefenseTechnology,
            MetallurgicalEngineering,
            MoldDesign,
            MechanicalEngineering,
            NanoEngineering,
            RefrigerationAirConditioningEngineering,
            UrbanEngineering,
            RoboticsEngineering,
            UnmannedAviation,
            SemiconductorStudies,
            IndustrialFacilityAutomation,
            TextileStudies,
            CeramicEngineering,
            FireProtection,
            SystemsEngineering,
            NewMaterialsEngineering,
            RenewableEnergy,
            SafetyEngineering,
            EnergyResourcesEngineering,
            NuclearEngineering,
            AutomotiveEngineering,
            ElectricalEngineering,
            ElectronicsEngineering,
            InformationSecurity,
            ControlMeasurementEngineering,
            PaperEngineering,
            LandscapeArchitecture,
            EarthMarineScience,
            RailwayTransportation,
            SurveyingInformation,
            CivilEngineering,
            SpecialEquipment,
            AerospaceEngineering,
            ChemicalEngineering,
            EnvironmentalChemistry,
        ),
    ),
    NATURAL_SCIENCES(
        "자연과학계열",
        listOf(
            LifeSciences,
            CulinaryArts,
            Horticulture,
            AgricultureFisheries,
            EnvironmentalEngineering,
            Zoology,
            PharmaceuticalEngineering,
            FoodScience,
            VeterinaryMedicine,
            Astronomy,
            Physics,
            Mathematics,
            Chemistry,
            Clothing,
            ForestEngineering,
            Geology,
            Geography2,
        ),
    ),
    MEDICAL_HEALTH(
        "의학보건계열",
        listOf(
            Medicine,
            Nursing,
            Pharmacy,
            Dentistry,
            PhysicalTherapy,
            KoreanMedicine,
            EnvironmentalHealth,
            EmergencyMedicalTechnology,
            MedicalAdministration,
            MedicalEquipmentEngineering,
            ClinicalPathology,
            Radiology,
            FireSafetyManagement,
            ArtTherapy,
            SpeechRehabilitation,
        ),
    ),
    ART_PHYSICAL(
        "예체능계열",
        listOf(
            FineArts,
            AppliedArts,
            Sculpture,
            Crafts,
            IndustrialDesign,
            GraphicDesign,
            MediaFilmStudies,
            Animation,
            InstrumentalMusic,
            VocalMusic,
            Music,
            PracticalMusic,
            DramaFilm,
            FashionDesign,
            InteriorDesign,
            AdvertisingDesign,
            DanceSports,
            SocialSports,
            SecurityStudies,
            HealthCare,
            MakeupArtistry,
            Modeling,
            Gemology,
            CommercialDiving,
        ),
    ),
    NONE("미선택", listOf(NOT_SELECTED)),
    ;

    companion object {
        fun findByDepartmentDetail(departmentDetail: DepartmentDetail): DepartmentGroup {
            return entries.stream().filter { it.departments.contains(departmentDetail) }.findFirst().orElse(NONE)
        }
    }
}
