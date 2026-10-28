import { TestBed } from '@angular/core/testing';

import { LowerSectionService } from './lower-section.service';

describe('LowerSectionService', () => {
  let service: LowerSectionService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(LowerSectionService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
