import {
  MaxLength,
  IsString,
  MinLength,
  IsNumber,
  IsEnum,
  IsDateString,
  IsObject,
} from 'class-validator';

enum visaTypes {
  education = 'education',
  job = 'job',
  tourist = 'tourist',
}

enum gender {
  male = 'male',
  female = 'female',
}

export class CreateApplicantDto {
  @IsNumber()
  userId: number;

  @IsString()
  @MaxLength(10)
  @MinLength(10)
  nationalId: string;

  @IsNumber()
  destCountryId: number;

  @IsEnum(visaTypes)
  @IsString()
  visaType: visaTypes;

  @IsString()
  fieldOfStudy: string;

  @IsString()
  @MaxLength(11)
  superVisorMobile: string;

  @IsString()
  @MaxLength(2)
  @MinLength(2)
  studyLanguage: string;

  @IsString()
  fileNumber: string;

  @IsString()
  grade: string;

  @IsString()
  telephone: string;

  @IsString()
  state: string;

  @IsString()
  city: string;

  @IsString()
  passportNumber: string;

  @IsDateString()
  passportExpireDate: Date;

  @IsDateString()
  passportIssueDate: Date;

  @IsString()
  address: string;

  @IsEnum(gender)
  gender: gender;
}

export class CreateApplicantInformationDto {
  @IsNumber()
  applicantId: number;

  @IsNumber()
  contractId: number;

  @IsNumber()
  dataGroupId: string;

  @IsObject()
  fields: object;

  @IsObject()
  values: object;
}

export class CreateApplicantDataGroupDto {
  @IsString()
  title: string;

  @IsString()
  description: string;
}
