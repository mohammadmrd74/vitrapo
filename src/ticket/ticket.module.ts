import { Module } from '@nestjs/common';
import { TicketService } from './ticket.service';
import { TicketController } from './ticket.controller';
import { MinioClientModule } from 'src/minio-client/minio-client.module';

@Module({
  imports: [MinioClientModule],
  controllers: [TicketController],
  providers: [TicketService],
})
export class TicketModule {}
