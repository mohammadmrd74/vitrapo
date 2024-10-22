import {
  Request,
  Body,
  Controller,
  Post,
  UseGuards,
  Get,
  Query,
  DefaultValuePipe,
  ParseIntPipe,
} from '@nestjs/common';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import { NotificationService } from './notification.service';
import { CreateNotificationDto } from './dto/notification.dto';

@Controller('notification')
export class NotificationController {
  constructor(private readonly notificationService: NotificationService) {}

  @Post('/')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  addNotification(@Body() notification: CreateNotificationDto) {
    return this.notificationService.insertNotification(notification);
  }

  @Get('/')
  @UseGuards(AuthenticationGuard)
  getNotification(
    @Request() req: Request & { user: vtUser },
    @Query('take', new DefaultValuePipe(20), ParseIntPipe) take: number,
    @Query('skip', new DefaultValuePipe(0), ParseIntPipe) skip: number,
  ) {
    return this.notificationService.getNotifications(req.user, take, skip);
  }
}
