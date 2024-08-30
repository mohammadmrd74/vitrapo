import {
  MaxLength,
  IsString,
  IsNumber,
  IsOptional,
  IsArray,
} from 'class-validator';

export class CreateDocumentDto {
  @IsString()
  docTitle: string;

  @IsString()
  @MaxLength(200)
  docDescription: string;

  @IsNumber()
  hasTranslate: number = 0;

  @IsNumber()
  @IsOptional()
  documentGroupId: number;

  @IsString()
  @IsOptional()
  documentGroupTitle: string;
}

export class CreateApplicantDocumentDto {
  @IsNumber()
  applicantId: number;

  @IsNumber()
  contractId: number;

  @IsArray()
  @IsNumber({}, { each: true })
  documentIds: number[];
}

export class CreateContractApplicantDocumenFileDto {
  @IsString()
  applicantId: string;

  @IsString()
  contractId: string;

  @IsString()
  documentId: string;
}
