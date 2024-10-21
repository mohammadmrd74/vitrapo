import {
  MaxLength,
  IsString,
  IsNumber,
  IsOptional,
  IsArray,
  IsEnum,
} from 'class-validator';

export enum selectedUser {
  empty = 'empty',
  approved = 'approved',
  rejected = 'rejected',
  waiting = 'waiting',
}

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
export class ChangeStatusDocumentDto {
  @IsNumber()
  documentId: number;

  @IsEnum(selectedUser)
  status: selectedUser;
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

export class CreateContractApplicantDocumenMessageDto {
  @IsNumber()
  ACDId: number;

  @IsString()
  message: string;
}
