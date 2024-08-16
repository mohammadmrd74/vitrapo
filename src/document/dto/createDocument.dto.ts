import { MaxLength, IsString, IsNumber, IsOptional } from 'class-validator';

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
