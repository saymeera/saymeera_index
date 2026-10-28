import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PubliFooterComponent } from './publi-footer.component';

describe('PubliFooterComponent', () => {
  let component: PubliFooterComponent;
  let fixture: ComponentFixture<PubliFooterComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [PubliFooterComponent]
    });
    fixture = TestBed.createComponent(PubliFooterComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
