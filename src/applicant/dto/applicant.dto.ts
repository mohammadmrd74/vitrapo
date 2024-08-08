import {
  MaxLength,
  IsString,
  MinLength,
  Length,
  IsNumber,
  IsEnum,
  IsDate,
  IsDateString,
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
  @IsString()
  @Length(10, 10)
  nationalId: string;

  @IsNumber()
  userId: number;

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
