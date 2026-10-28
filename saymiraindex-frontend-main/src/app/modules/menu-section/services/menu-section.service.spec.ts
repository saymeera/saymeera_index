import { TestBed } from '@angular/core/testing';

import { MenuSectionService } from './menu-section.service';

describe('MenuSectionService', () => {
  let service: MenuSectionService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MenuSectionService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
