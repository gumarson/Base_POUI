import { HttpClient } from "@angular/common/http";
import { inject, Injectable } from "@angular/core";
import { Router } from "@angular/router";
import { Observable } from "rxjs";
import { environment } from "./environments/environment";
import { LoginData } from "./classes/login";

@Injectable({providedIn: 'root'})

export class LoginAuthService {

    private http = inject(HttpClient);
    private url: string = environment.url;
    private router = inject(Router);

    public sendLogin(username: string, password: string): Observable<LoginData> {
        let urlLogin: string = `${this.url}/api/oauth2/v1/token?grant_type=password&username=${username}&password=${password}`
        return this.http.post<LoginData>(urlLogin,null);
    }

    // public refreshLogin(refresh_token: string): Observable<LoginData> {
    //     let urlRefresh: string = ${this.url}/api/oauth2/v1/token?grant_type=refresh_token&refresh_token=${refresh_token}
    //     return this.http.post<LoginData>(urlRefresh,null);
    // }
}