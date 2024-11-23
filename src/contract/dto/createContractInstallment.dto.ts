import {
  MaxLength,
  IsString,
  IsNumber,
  Length,
  IsDateString,
  Max,
  IsEnum,
} from 'class-validator';

export enum insStatus {
  empty = 'empty',
  approved = 'approved',
  rejected = 'rejected',
  waiting = 'waiting',
  expertWaiting = 'expertWaiting',
}
export class CreateContractInstallmentDto {
  @IsNumber()
  contractId: number;

  @IsString()
  @MaxLength(100)
  title: string;

  @IsNumber()
  @Max(30)
  installmentNumber: number;

  @IsNumber()
  price: number;

  @IsString()
  @Length(3, 3)
  priceCurrency: string = 'IRR';

  @IsDateString()
  dueDate: Date;

  @IsNumber()
  deadLine: number = 0;
}

export class CreateContractInstallmentFileDto {
  @IsString()
  installmentId: string;
}
export class installmentStatusDto {
  @IsNumber()
  installmentId: number;

  @IsEnum(insStatus)
  status: insStatus;
}

export class CreateInstallmentMessageDto {
  @IsNumber()
  installmentId: number;

  @IsString()
  @MaxLength(200)
  message: string;
}
