import {
  Body,
  Controller,
  Get,
  Post,
  UseGuards,
  Request,
  ParseIntPipe,
  Query,
  DefaultValuePipe,
} from '@nestjs/common';
import { AuthenticationGuard, vtUser } from 'src/auth/authentication.guard';
import { AuthorizationGuard } from 'src/auth/authorization.guard';
import { AdminService } from './admin.service';

@Controller('admin')
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('/countries')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getCountries() {
    return this.adminService.getCountries();
  }

  @Get('/roles')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getRoles() {
    return this.adminService.getRoles();
  }

  @Get('/users')
  @UseGuards(AuthenticationGuard, AuthorizationGuard)
  getUsers(
    @Query('take', new DefaultValuePipe(20), ParseIntPipe) take: number,
    @Query('skip', new DefaultValuePipe(0), ParseIntPipe) skip: number,
    @Query('roleId', new DefaultValuePipe(-1), ParseIntPipe) roleId: number,
  ) {
    return this.adminService.getUsers(take, skip, roleId);
  }
}
