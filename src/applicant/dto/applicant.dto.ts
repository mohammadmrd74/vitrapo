import {
  MaxLength,
  IsString,
  MinLength,
  IsNumber,
  IsEnum,
  IsDateString,
  IsObject,
  IsArray,
  IsOptional,
  IsBoolean,
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

type field = {
  type: string;
  key: string;
  label: string;
  validations: object;
};

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

export class ConfirmApplicantDto {
  @IsNumber()
  applicantId: number;
}
export class AdminConfirmApplicantDto {
  @IsNumber()
  applicantId: number;

  @IsBoolean()
  confirm: boolean;
}

export class CreateApplicantInformationDto {
  @IsNumber()
  applicantId: number;

  @IsNumber()
  @IsOptional()
  contractId: number;

  @IsNumber()
  dataGroupId: number;

  @IsObject()
  @IsOptional()
  values: object;
}

export class CreateAssignExpertDto {
  @IsNumber()
  applicantId: number;

  @IsArray()
  @IsNumber({}, { each: true })
  expertIds: Array<number>;
}

export class CreateApplicantDataGroupDto {
  @IsString()
  title: string;

  @IsString()
  description: string;

  @IsArray()
  fields: field[];
}
