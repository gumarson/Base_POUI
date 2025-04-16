import { TestBed } from '@angular/core/testing';

import { Sh8Service } from './sh8.service';

describe('Sh8Service', () => {
  let service: Sh8Service;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(Sh8Service);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
