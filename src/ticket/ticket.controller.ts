import {
  Body,
  Controller,
  DefaultValuePipe,
  Get,
  ParseIntPipe,
  Post,
  Query,
  Request,
  UploadedFiles,
  UseGuards,
  UseInterceptors,
} from '@nestjs/common';
import { TicketService } from './ticket.service';
import { AnyFilesInterceptor } from '@nestjs/platform-express';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import {
  CreateTicketDto,
  CreateTicketMessageDto,
} from './dto/createTicket.dto';
import { CreateTicketCategoryDto } from './dto/createTicketCategory.dto';
import { FilesValidationPipe } from 'src/common/validationPipes/fileValidationPipe';

@Controller('ticket')
export class TicketController {
  constructor(private readonly ticketService: TicketService) {}

  @Post('/category')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addTicketCategory(@Body() document: CreateTicketCategoryDto) {
    return this.ticketService.addTicketCategory(document);
  }

  @Get('/category')
  @UseGuards(AuthenticationGuard)
  getTicketCategory() {
    return this.ticketService.getTicketCategory();
  }

  @UseGuards(AuthenticationGuard)
  @Post('/')
  @UseInterceptors(AnyFilesInterceptor())
  insertTicket(
    @Body() body: CreateTicketDto,
    @UploadedFiles(new FilesValidationPipe())
    files: Array<Express.Multer.File>,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.ticketService.insertTicket(body, files, req.user, 'tickets');
  }

  @UseGuards(AuthenticationGuard)
  @Post('/reply')
  @UseInterceptors(AnyFilesInterceptor())
  replyTicket(
    @Body() body: CreateTicketMessageDto,
    @UploadedFiles(new FilesValidationPipe())
    files: Array<Express.Multer.File>,
    @Request() req: Request & { user: vtUser },
  ) {
    return this.ticketService.replyTicket(body, files, req.user, 'tickets');
  }

  @UseGuards(AuthenticationGuard)
  @Get('/')
  getAllTickets(
    @Request() req: Request & { user: vtUser },
    @Query('take', new DefaultValuePipe(20), ParseIntPipe) take: number,
    @Query('skip', new DefaultValuePipe(0), ParseIntPipe) skip: number,
  ) {
    return this.ticketService.getAllTickets(req.user, take, skip);
  }

  @UseGuards(AuthenticationGuard)
  @Get('/reply')
  getTicketReplies(
    @Request() req: Request & { user: vtUser },
    @Query('ticketId', ParseIntPipe) ticketId: number,
  ) {
    return this.ticketService.getTicketReplies(req.user, ticketId);
  }
}
