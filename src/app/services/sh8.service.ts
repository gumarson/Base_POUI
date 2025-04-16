// import { Injectable } from '@angular/core';

// @Injectable({
//   providedIn: 'root'
// })
// export class Sh8Service {

//   constructor() { }
// }

import { HttpClient, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class Sh8Service {

  private readonly baseUrl = 'http://localhost:8080/rest/wscolet/sh8';

  constructor(private http: HttpClient) {}

  getDados(centroTrabalho: string, dataInicio: string, dataFim: string): Observable<any> {
    console.log('➡️ Enviando para API:');
    console.log('Centro de Trabalho:', centroTrabalho);
    console.log('Data Início:', dataInicio);
    console.log('Data Fim:', dataFim);

    const params = new HttpParams()
      .set('_cCentro', centroTrabalho)
      .set('_dInicio', dataInicio)
      .set('_dFim', dataFim);

    return this.http.get<any>(this.baseUrl, { params });
  }
}
