import { TestBed } from '@angular/core/testing';

import { MidSectionService } from './mid-section.service';

describe('MidSectionService', () => {
  let service: MidSectionService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(MidSectionService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
