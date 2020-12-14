//
//  HttpsUtil.cpp
//  EncryptionWithCppAlgorithm
//
//  Created by VanZhang on 2020/11/20.
//

#include "HttpsUtil.hpp"
//#include <bits/stdc++.h>
#include <string.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <signal.h>
#include <sys/wait.h>
#define SZ 10
 


using namespace std;
int HttpClient(char ipAddress[],int portNumber){
    struct sockaddr_in remote_addr;
    memset(&remote_addr,0,sizeof(remote_addr));
    remote_addr.sin_family=AF_INET; //设置为IP通信
    remote_addr.sin_addr.s_addr=inet_addr("127.0.0.1");//服务器IP地址
    remote_addr.sin_port=htons(8000); //服务器端口号
    //创建客户端套接字 IPv4 tcp
    int client_sockfd=socket(AF_INET,SOCK_STREAM,0);
    if(client_sockfd<0)
    {
        perror("socket error");
        return 1;
    }
    //绑定服务器网络地址
    if(connect(client_sockfd,(struct sockaddr*)&remote_addr,sizeof(remote_addr))<0)
    {
        perror("connect error");
        return 1;
    }
    printf("connected to server sucessfully\n");
    char buf[SZ]={0};
    while(1)
    {
        printf("Enter string to send:");
        scanf(" %s",buf);
        if(!strcmp(buf,"quit")) break;
        int len=send(client_sockfd,buf,strlen(buf),0);
        len=recv(client_sockfd,buf,BUFSIZ,0);
        buf[len]='\0';
        printf("received:%s\n",buf);
    }
    close(client_sockfd);
    return 0;
}

#pragma Server 
int crea_socket()
{
    int listen_socket=socket(AF_INET,SOCK_STREAM,0);
    if(listen_socket==-1)
    {
        perror("create socket error");
        return -1;
    }
    sockaddr_in addr;
    memset(&addr,0,sizeof(addr));
    addr.sin_family=AF_INET;
    addr.sin_port=htons(8000);
    addr.sin_addr.s_addr=htonl(INADDR_ANY);
    if((bind(listen_socket,(sockaddr*)&addr,sizeof(addr)))==-1)
    {
        perror("bind error");
        return -1;
    }
    if((listen(listen_socket,5))==-1)
    {
        perror("listen error");
        return -1;
    }
    return listen_socket;
}
int wait_client(int listen_socket)
{
    sockaddr_in addr;
    socklen_t sz=sizeof(addr);
    printf("wait client to connect...\n");
    int client_socket=accept(listen_socket,(sockaddr*)&addr,&sz);
    if(client_socket==-1)
    {
        perror("accept error");
        return -1;
    }
    printf("sucessful listen a client %s\n",inet_ntoa(addr.sin_addr));
    return client_socket;
}
void hanld_client(int listen_socket,int client_socket)
{
    char buf[SZ];
    while(1)
    {
        int len=recv(client_socket,buf,SZ-1,0);
        if(len<0)
        {
            perror("recv error");
            break;
        }
        if(len==0) break;
        buf[len]='\0';
        printf("receive string:%s\n",buf);
        send(client_socket,buf,len,0);
        if(strncmp(buf,"end",3)==0) break;
    }
    close(client_socket);
}
void handler(int sig)
{
    while(waitpid(-1,NULL,WNOHANG)>0)
    {
        printf("成功处理一个子进程");
    }
}
void HttpServer()
{
    int listen_sockfd=crea_socket();
    signal(SIGCHLD,handler);
    while(1)
    {
        int client_sockfd=wait_client(listen_sockfd);
        int pid=fork();
        if(pid==-1)
        {
            perror("fork error");
            break;
        }
        if(pid>0)
        {
            close(client_sockfd);
            continue;
        }
        if(pid==0)
        {
            close(listen_sockfd);
            hanld_client(listen_sockfd,client_sockfd);
            break;
        }
    }
    close(listen_sockfd);

}

