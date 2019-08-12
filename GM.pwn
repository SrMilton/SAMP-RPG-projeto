#include <a_samp>
#include <sscanf2>
#include <streamer>
//#include <nex-ac>
#include <a_mysql>
#include <pawn.CMD>

#pragma tabsize 0
#pragma dynamic 145000

#define DIALOG_REGISTRO     1
#define DIALOG_LOGIN     2
#define DIALOG_AMMOCLAN 3
#define DIALOG_CRIARCASA 4
#define DIALOG_MEMBROS 5
#define DIALOG_MEMBROS_ACAO 6
#define DIALOG_MEMBROS_NORMAL 7
#define DIALOG_BINCO_COMPRAR 8
#define DIALOG_IMOBILIARIA 9

//==============DEFINE CORES====================
#define amarelo 0xFFFF00FF
#define vermelho 0xFF0000FF
#define azul_claro 0x00FFFFFF
#define dourado 0xFFCC00FF
#define azul_escuro 0x0000FFFF
#define roxo 0xCC0099FF
#define rosa 0xFF0099FF
#define verde 0x00CC00FF
#define vinho 0x660000FF

#define brancoclaro 0xE0FFFFAA


#define COLOR_FADE1 0xFFFFFFFF
#define COLOR_FADE2 0xC8C8C8C8
#define COLOR_FADE3 0xAAAAAAAA
#define COLOR_FADE4 0x8C8C8C8C
#define COLOR_FADE5 0x6E6E6E6E
#define COLOR_WHITE  0xFFFFFFFF
//==============================================

#define PRESSED(%0) \
	(((newkeys & (%0)) == (%0)) && ((oldkeys & (%0)) != (%0)))

new MySQL:IDConexao; // Variavel responsavel pela ID da conexão com o host
new TempoSec = 0;
new Forcepd = 0;
new buycar;
new IntID;
new Valor;
new counthouse;
new Text:Time, Text:Date;
new PlayerText:Vel[MAX_PLAYERS];
new PlayerText:Gas[MAX_PLAYERS];
new Text3D:MyLabel[960];
new countcarros;

new HouseID[MAX_PLAYERS];
new slot[MAX_PLAYERS];
new conviteorg[MAX_PLAYERS];
new membros[MAX_PLAYERS];
new orgnumber[MAX_PLAYERS];
new nocaixa[MAX_PLAYERS];
new tempoon[MAX_PLAYERS];
new hqid[MAX_PLAYERS];
new gasolina[MAX_VEHICLES];


enum pInfo // enumerador com variaveis necessarias para nosso salvamento.
{
    pID,
    pNome[24],
    pIP[26],
    pSenha[20],
    pLevel,
    pDinheiro,
    pSkin,
    pMatou,
    pMorreu,
    pAdmin,
    pX,
	pY,
	pZ,
	pRot,
	pSaldo,
	pOrg,
	pHealth,
	pArmour,
	pResp,
	pRespobj,
    bool:pLogado
};

enum pArmas
{
	pID,
	pArma1,
	pArma2,
	pArma3,
	pArma4,
	pArma5,
	pArma6,
	pArma7,
	pArma8,
	pArma9,
	pArma10,
	pArma11,
	pArma12,
	pAmmo1,
	pAmmo2,
	pAmmo3,
	pAmmo4,
	pAmmo5,
	pAmmo6,
	pAmmo7,
	pAmmo8,
	pAmmo9,
	pAmmo10,
	pAmmo11,
	pAmmo12,
};

enum pCasas
{
	pID,
	pIntID,
	Float:pPicx,
	Float:pPicy,
	Float:pPicz,
	Float:pIntx,
	Float:pInty,
	Float:pIntz,
	pValor,
	pDono,
	pVirtualW,
};

enum pOrgs
{
	ID,
	pID,
	Nivel,
};


enum vInfo // enumerador com variaveis de carro
{
    pID,
	pModel,
	Float:pX,
	Float:pY,
	Float:pZ,
	Float:pRot,
	pColor1,
	pColor2,
	pPaintjob,
	pC0,
	pC1,
	pC2,
	pC3,
	pC4,
	pC5,
	pC6,
	pC7,
	pC8,
	pC9,
	pC10,
	pC11,
	pC12,
	pC13,
	pDono,
};

enum HQ
{
	pID,
	pIntID,
	pNome[30],
	Float:pPicx,
	Float:pPicy,
	Float:pPicz,
	Float:pIntx,
	Float:pInty,
	Float:pIntz,
	Float:cofrex,
	Float:cofrey,
	Float:cofrez,
	VirtualW,
};

new PlayerInfo[MAX_PLAYERS][pInfo];
new VehicleInfo[MAX_VEHICLES][vInfo];
new PlayerWeap[MAX_PLAYERS][pArmas];
new HouseInfo[MAX_PLAYERS][pCasas];
new OrgInfo[MAX_PLAYERS][pOrgs];
new HQInfo[MAX_PLAYERS][HQ];


#define HOST      "localhost" // IP de acesso ao phpmyadmin no caso se voce estiver hospedando no pc deixei localhost
#define USUARIO   "root" // Usuario por padrão é root
#define DATABASE  "samp" // nome da database que voce criou.. como explicao no video acima
#define SENHA     ""   // não possue senha caso tenha usado o wamp


main(){}

public OnGameModeInit()
{
    IDConexao = mysql_connect(HOST, USUARIO, SENHA, DATABASE); // faremos a conexão ao host com as informações definidas acima
    new stringcon[954];
    new stringcon1[954];
    new stringcon2[954];
    new stringcon3[954];
    new stringcon4[954];
    new stringcon5[954];
    new stringcon6[954];
   	new stringcon7[954];
    new stringcon8[954];
    new stringcon9[954];
    new stringcon10[954];
    new stringcon11[954];
    new stringcon12[954];
    
    strcat(stringcon, "CREATE TABLE IF NOT EXISTS `Contas`(`ID`int AUTO_INCREMENT PRIMARY KEY, `Nome`varchar(24) NOT NULL DEFAULT ' ',`Senha` varchar(20) NOT NULL DEFAULT ' ',`Level` int(20) NOT NULL DEFAULT 0,`Matou` int(10) NOT NULL DEFAULT 0,`Morreu` int(10) NOT NULL DEFAULT 0,`Skin` int(10) NOT NULL DEFAULT 0,`Admin` int(10) NOT NULL DEFAULT 0,");
    strcat(stringcon, "`X` float(20) NOT NULL DEFAULT 0,`Y` float(20) NOT NULL DEFAULT 0,`Z` float(20) NOT NULL DEFAULT 0,`Rot` float(20) NOT NULL DEFAULT 0,`Saldo` int(20) NOT NULL DEFAULT 0,`Org` int(20) NOT NULL DEFAULT 0,`Health` float(20) NOT NULL DEFAULT 0,`Armour` float(20) NOT NULL DEFAULT 0,");
    strcat(stringcon, "`Respeito` int(20) NOT NULL DEFAULT 0,`Respeitoobj` int(20) NOT NULL DEFAULT 0,");
    strcat(stringcon, "`Dinheiro` int(20) NOT NULL DEFAULT 0)");
    
	mysql_query(IDConexao, stringcon, false);
	
 	if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
	
 	strcat(stringcon1, "CREATE TABLE IF NOT EXISTS `Carros`(`ID`int AUTO_INCREMENT PRIMARY KEY, `Model` int(20) NOT NULL DEFAULT 0, `X` float(20) NOT NULL DEFAULT 0, `Y` float(20) NOT NULL DEFAULT 0, `Z` float(20) NOT NULL DEFAULT 0,`Rot` float(20) NOT NULL DEFAULT 0, `Color1` int(20) NOT NULL DEFAULT 0, `Color2` int(20) NOT NULL DEFAULT 0,");
 	strcat(stringcon1, "`Paintjob` int(20) NOT NULL DEFAULT 0,`C0` int(20) NOT NULL DEFAULT 0, `C1` int(20) NOT NULL DEFAULT 0, `C2` int(20) NOT NULL DEFAULT 0, `C3` int(20) NOT NULL DEFAULT 0, `C4` int(20) NOT NULL DEFAULT 0, `C5` int(20) NOT NULL DEFAULT 0, `C6` int(20) NOT NULL DEFAULT 0, `C7` int(20) NOT NULL DEFAULT 0,");
 	strcat(stringcon1, "`C8` int(20) NOT NULL DEFAULT 0,`C9` int(20) NOT NULL DEFAULT 0,`C10` int(20) NOT NULL DEFAULT 0,`C11` int(20) NOT NULL DEFAULT 0,`C12` int(20) NOT NULL DEFAULT 0,`C13` int(20) NOT NULL DEFAULT 0,`Dono` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon1, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }

    
    strcat(stringcon2, "CREATE TABLE IF NOT EXISTS `Armas`(`ID`int AUTO_INCREMENT PRIMARY KEY,");
    strcat(stringcon2, "`Arma1` int(20) NOT NULL DEFAULT 0,`Arma2` int(20) NOT NULL DEFAULT 0,`Arma3` int(20) NOT NULL DEFAULT 0,`Arma4` int(20) NOT NULL DEFAULT 0,");
    strcat(stringcon2, "`Arma5` int(20) NOT NULL DEFAULT 0,`Arma6` int(20) NOT NULL DEFAULT 0,`Arma7` int(20) NOT NULL DEFAULT 0,`Arma8` int(20) NOT NULL DEFAULT 0,`Arma9` int(20) NOT NULL DEFAULT 0,`Arma10` int(20) NOT NULL DEFAULT 0,`Arma11` int(20) NOT NULL DEFAULT 0,`Arma12` int(20) NOT NULL DEFAULT 0,");
    strcat(stringcon2, "`Ammo1` int(20) NOT NULL DEFAULT 0,`Ammo2` int(20) NOT NULL DEFAULT 0,`Ammo3` int(20) NOT NULL DEFAULT 0,`Ammo4` int(20) NOT NULL DEFAULT 0,`Ammo5` int(20) NOT NULL DEFAULT 0,`Ammo6` int(20) NOT NULL DEFAULT 0,");
    strcat(stringcon2, "`Ammo7` int(20) NOT NULL DEFAULT 0,`Ammo8` int(20) NOT NULL DEFAULT 0,`Ammo9` int(20) NOT NULL DEFAULT 0,`Ammo10` int(20) NOT NULL DEFAULT 0,`Ammo11` int(20) NOT NULL DEFAULT 0,`Ammo12` int(20) NOT NULL DEFAULT 0)");
	mysql_query(IDConexao, stringcon2, false);
	
 	if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    
   	strcat(stringcon3, "CREATE TABLE IF NOT EXISTS `Casas`(`ID`int AUTO_INCREMENT PRIMARY KEY, `IntID` int(20) NOT NULL DEFAULT 0, `Picx` float(20) NOT NULL DEFAULT 0, `Picy` float(20) NOT NULL DEFAULT 0, `Picz` float(20) NOT NULL DEFAULT 0, `Intx` float(20) NOT NULL DEFAULT 0,`Inty` float(20) NOT NULL DEFAULT 0,");
    strcat(stringcon3, "`Intz` float(20) NOT NULL DEFAULT 0, `Valor` int(20) NOT NULL DEFAULT 0, `Dono` int(20) NOT NULL DEFAULT 0,`VirtualW` int(20) NOT NULL DEFAULT 0)");
    
	mysql_query(IDConexao, stringcon3, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
   	strcat(stringcon4, "CREATE TABLE IF NOT EXISTS `pmlv`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon4, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
   	strcat(stringcon5, "CREATE TABLE IF NOT EXISTS `pmls`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon5, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    strcat(stringcon6, "CREATE TABLE IF NOT EXISTS `pc`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon6, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    strcat(stringcon7, "CREATE TABLE IF NOT EXISTS `mafia1`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon7, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    strcat(stringcon8, "CREATE TABLE IF NOT EXISTS `mafia2`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon8, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    strcat(stringcon9, "CREATE TABLE IF NOT EXISTS `gangue1`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon9, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    strcat(stringcon10, "CREATE TABLE IF NOT EXISTS `gangue2`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon10, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
    strcat(stringcon11, "CREATE TABLE IF NOT EXISTS `samu`(`ID`int AUTO_INCREMENT PRIMARY KEY, `pID` int(20) NOT NULL DEFAULT 0, `Nivel` int(20) NOT NULL DEFAULT 0)");

	mysql_query(IDConexao, stringcon11, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }
    
   	strcat(stringcon12, "CREATE TABLE IF NOT EXISTS `HQ`(`ID`int(20) NOT NULL DEFAULT 0, `IntID` int(20) NOT NULL DEFAULT 0, `Picx` float(20) NOT NULL DEFAULT 0, `Picy` float(20) NOT NULL DEFAULT 0, `Picz` float(20) NOT NULL DEFAULT 0, `Intx` float(20) NOT NULL DEFAULT 0,`Inty` float(20) NOT NULL DEFAULT 0,");
    strcat(stringcon12, "`Intz` float(20) NOT NULL DEFAULT 0,`cofrex` float(20) NOT NULL DEFAULT 0,`cofrey` float(20) NOT NULL DEFAULT 0,`cofrez` float(20) NOT NULL DEFAULT 0, `Nome`varchar(30) NOT NULL DEFAULT ' ', `VirtualW`int AUTO_INCREMENT PRIMARY KEY)");

	mysql_query(IDConexao, stringcon12, false);

    if(mysql_errno(IDConexao) != 0) // Ultilizo essa maneira para saber se a conexão foi bem sucedida ou não
    {
        print("Falha na conexão ao banco de dados Mysql");
        } else {
        print("Conexão ao banco de dado Mysql efetuada com sucesso");
    }

    
//===================================================================================================================
    
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_OFF);
    SetNameTagDrawDistance(9.0);
    SincronizarTempo();
    SetClima();
    CarregarCarros();
    DisableInteriorEnterExits();
    ManualVehicleEngineAndLights();
    ContarCasas();
    CriarOrgs();
    CriarHQs();
    CarregarHQs();
    CarregarLojas();
	ContarGasolina();
    
   // SetTimer("SincronizarTempo", 1, false);
 //   SetTimer("PayDay", TempoSec, true);
 
 //=============================OVERLAY HORARIO======================================
     SetTimer("Overlays",1000,true);

        Date = TextDrawCreate(547.000000,11.000000,"--");

        TextDrawFont(Date,3);
        TextDrawLetterSize(Date,0.399999,1.600000);
    	TextDrawColor(Date,0xffffffff);

        Time = TextDrawCreate(547.000000,28.000000,"--");

        TextDrawFont(Time,3);
        TextDrawLetterSize(Time,0.399999,1.600000);
        TextDrawColor(Time,0xffffffff);
 
 
//================================================CRIAR OBJETOS===============================================
//================================================CRIAR OBJETOS===============================================
//================================================CRIAR OBJETOS===============================================
//================================================CRIAR OBJETOS===============================================
//================================================CRIAR OBJETOS===============================================
//================================================CRIAR OBJETOS===============================================
//================================================CRIAR OBJETOS===============================================

//==============================CAIXAS===================================

CreateDynamicObject(2942,1928.7000000,-1783.7000000,13.2000000,0.0000000,0.0000000,92.0000000); //object(kmb_atm1) (2)
CreateDynamicObject(2942,1013.7000000,-928.7999900,42.0000000,0.0000000,0.0000000,6.2500000); //object(kmb_atm1) (3)
CreateDynamicObject(2942,735.4331100,-1440.4490000,13.2000000,0.0000000,0.0000000,181.5000000); //object(kmb_atm1) (4)
CreateDynamicObject(2942,666.3272700,-552.2775900,16.0000000,0.0000000,0.0000000,179.2500000); //object(kmb_atm1) (5)
CreateDynamicObject(2942,1389.2513000,462.8869900,19.8000000,0.0000000,0.0000000,336.5000000); //object(kmb_atm1) (6)
CreateDynamicObject(2942,2107.3420000,896.7758800,10.8000000,0.0000000,0.0000000,180.0000000); //object(kmb_atm1) (7)
CreateDynamicObject(2942,2631.8035000,1129.6782000,10.8000000,0.0000000,0.0000000,0.0000000); //object(kmb_atm1) (8)
CreateDynamicObject(2942,2140.3999000,2733.8999000,10.8000000,0.0000000,0.0000000,180.0000000); //object(kmb_atm1) (9)
CreateDynamicObject(2942,1603.1000000,2229.2000000,10.7000000,0.0000000,0.0000000,90.7500000); //object(kmb_atm1) (10)
CreateDynamicObject(2942,666.9672200,1721.0043000,6.8000000,0.0000000,0.0000000,221.0000000); //object(kmb_atm1) (11)

//=========================================================================
//==========================PROTEÇÃO POSTO SUL LS==============================
CreateDynamicObject(997,1942.3000000,-1780.3000000,12.7000000,359.7470000,0.0000000,90.0000000); //object(lhouse_barrier3) (1)
CreateDynamicObject(997,1942.3000000,-1777.2000000,12.7000000,359.7420000,0.0000000,90.0000000); //object(lhouse_barrier3) (2)
CreateDynamicObject(997,1942.3000000,-1774.1000000,12.7000000,359.7420000,0.0000000,90.0000000); //object(lhouse_barrier3) (3)
CreateDynamicObject(997,1942.3000000,-1771.0000000,12.7000000,359.7420000,0.0000000,90.0000000); //object(lhouse_barrier3) (4)
CreateDynamicObject(997,1942.3000000,-1767.9000000,12.7000000,359.7420000,0.0000000,90.0000000); //object(lhouse_barrier3) (5)
CreateDynamicObject(997,1941.1000000,-1780.3000000,12.7000000,359.7470000,0.0000000,90.0000000); //object(lhouse_barrier3) (7)
CreateDynamicObject(997,1941.1000000,-1777.2000000,12.7000000,359.7470000,0.0000000,90.0000000); //object(lhouse_barrier3) (8)
CreateDynamicObject(997,1941.1000000,-1774.1000000,12.7000000,359.7470000,0.0000000,90.0000000); //object(lhouse_barrier3) (9)
CreateDynamicObject(997,1941.1000000,-1771.0000000,12.7000000,359.7470000,0.0000000,90.0000000); //object(lhouse_barrier3) (10)
CreateDynamicObject(997,1941.1000000,-1767.9000000,12.7000000,359.7470000,0.0000000,90.0000000); //object(lhouse_barrier3) (11)
//==============================================================================

//===========================CERCA AVENIDA DE LV========================================
CreateDynamicObject(984,2139.6001000,2216.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (1)
CreateDynamicObject(984,2139.6001000,2203.8999000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (2)
CreateDynamicObject(984,2139.6001000,2191.1001000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (3)
CreateDynamicObject(984,2139.6001000,2178.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (4)
CreateDynamicObject(984,2139.6001000,2168.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (5)
CreateDynamicObject(984,2135.1001000,2216.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (6)
CreateDynamicObject(984,2135.1001000,2203.8999000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (7)
CreateDynamicObject(984,2135.1001000,2191.1001000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (8)
CreateDynamicObject(984,2135.1001000,2178.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (9)
CreateDynamicObject(984,2135.1001000,2168.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (10)
CreateDynamicObject(970,2137.3999000,2162.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (1)
CreateDynamicObject(984,2135.2000000,2117.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (11)
CreateDynamicObject(984,2135.2000000,2105.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (12)
CreateDynamicObject(984,2135.2000000,2092.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (13)
CreateDynamicObject(984,2135.2000000,2079.3999000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (14)
CreateDynamicObject(984,2135.2000000,2066.6001000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (15)
CreateDynamicObject(984,2135.2000000,2053.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (16)
CreateDynamicObject(984,2135.2000000,2041.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (17)
CreateDynamicObject(984,2135.2000000,2028.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (18)
CreateDynamicObject(984,2135.2000000,2015.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (19)
CreateDynamicObject(984,2135.2000000,2002.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (20)
CreateDynamicObject(984,2135.2000000,1989.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (21)
CreateDynamicObject(984,2135.2000000,1977.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (22)
CreateDynamicObject(984,2135.2000000,1964.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (23)
CreateDynamicObject(984,2135.2000000,1951.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (24)
CreateDynamicObject(984,2135.2000000,1938.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (25)
CreateDynamicObject(984,2135.2000000,1925.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (26)
CreateDynamicObject(984,2135.2000000,1913.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (27)
CreateDynamicObject(984,2135.2000000,1900.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (28)
CreateDynamicObject(984,2135.2000000,1887.5000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (29)
CreateDynamicObject(984,2135.2000000,1874.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (30)
CreateDynamicObject(984,2135.2000000,1869.9000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (31)
CreateDynamicObject(984,2139.5000000,2117.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (33)
CreateDynamicObject(984,2139.5000000,2104.8999000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (34)
CreateDynamicObject(984,2139.5000000,2092.1001000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (35)
CreateDynamicObject(984,2139.5000000,2079.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (36)
CreateDynamicObject(984,2139.5000000,2066.5000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (37)
CreateDynamicObject(984,2139.5000000,2053.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (38)
CreateDynamicObject(984,2139.5000000,2040.9000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (39)
CreateDynamicObject(984,2139.5000000,2028.1000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (40)
CreateDynamicObject(984,2139.5000000,2015.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (41)
CreateDynamicObject(984,2139.5000000,2002.5000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (42)
CreateDynamicObject(984,2139.5000000,1989.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (43)
CreateDynamicObject(984,2139.5000000,1976.9000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (44)
CreateDynamicObject(984,2139.5000000,1964.1000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (45)
CreateDynamicObject(984,2139.5000000,1951.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (46)
CreateDynamicObject(984,2139.5000000,1938.5000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (47)
CreateDynamicObject(984,2139.5000000,1925.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (48)
CreateDynamicObject(984,2139.5000000,1912.9000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (49)
CreateDynamicObject(984,2139.5000000,1900.1000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (50)
CreateDynamicObject(984,2139.5000000,1887.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (51)
CreateDynamicObject(984,2139.5000000,1874.5000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (52)
CreateDynamicObject(984,2139.5000000,1869.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (53)
CreateDynamicObject(984,2132.3000000,1857.8000000,10.4000000,0.0000000,0.0000000,333.5000000); //object(fenceshit2) (54)
CreateDynamicObject(984,2126.6001000,1846.3000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (55)
CreateDynamicObject(984,2120.8999000,1834.9000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (56)
CreateDynamicObject(984,2115.2000000,1823.4000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (57)
CreateDynamicObject(984,2109.5000000,1812.0000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (58)
CreateDynamicObject(984,2103.8000000,1800.6000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (59)
CreateDynamicObject(984,2098.0000000,1789.1000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (60)
CreateDynamicObject(984,2136.7000000,1857.6000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (61)
CreateDynamicObject(984,2131.0000000,1846.2000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (62)
CreateDynamicObject(984,2125.3000000,1834.7000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (63)
CreateDynamicObject(984,2119.6001000,1823.2000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (64)
CreateDynamicObject(984,2113.8999000,1811.8000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (65)
CreateDynamicObject(984,2108.2000000,1800.4000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (66)
CreateDynamicObject(984,2102.5000000,1788.9000000,10.4000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (67)
CreateDynamicObject(984,2101.8000000,1787.5000000,10.4000000,0.0000000,0.0000000,333.4950000); //object(fenceshit2) (68)
CreateDynamicObject(970,2097.0000000,1782.6000000,10.4000000,0.0000000,0.0000000,337.7500000); //object(fencesmallb) (3)
CreateDynamicObject(984,2082.7000000,1758.1000000,10.3000000,0.0000000,0.0000000,333.5000000); //object(fenceshit2) (69)
CreateDynamicObject(984,2077.0000000,1746.7000000,10.3000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (70)
CreateDynamicObject(984,2071.3000000,1735.3000000,10.3000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (71)
CreateDynamicObject(984,2067.7000000,1728.1000000,10.3000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (72)
CreateDynamicObject(984,2072.1001000,1728.2000000,10.3000000,0.0000000,0.0000000,333.5000000); //object(fenceshit2) (73)
CreateDynamicObject(984,2077.8000000,1739.6000000,10.3000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (74)
CreateDynamicObject(984,2083.5000000,1751.0000000,10.3000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (75)
CreateDynamicObject(984,2087.1001000,1758.2000000,10.3000000,0.0000000,0.0000000,333.4960000); //object(fenceshit2) (76)
CreateDynamicObject(970,2087.8000000,1764.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (4)
CreateDynamicObject(970,2067.0000000,1722.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (5)
CreateDynamicObject(984,2055.2000000,1697.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (77)
CreateDynamicObject(984,2055.2000000,1684.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (78)
CreateDynamicObject(984,2055.2000000,1671.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (79)
CreateDynamicObject(984,2055.2000000,1658.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (80)
CreateDynamicObject(984,2059.6001000,1658.9000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (81)
CreateDynamicObject(984,2059.6001000,1671.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (82)
CreateDynamicObject(984,2059.6001000,1684.5000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (83)
CreateDynamicObject(984,2059.6001000,1697.3000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (84)
CreateDynamicObject(970,2057.3999000,1703.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (6)
CreateDynamicObject(970,2057.3999000,1652.4000000,10.4000000,0.0000000,0.0000000,1.2500000); //object(fencesmallb) (7)
CreateDynamicObject(984,2055.2000000,1633.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (85)
CreateDynamicObject(984,2055.2000000,1620.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (86)
CreateDynamicObject(984,2055.2000000,1607.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (87)
CreateDynamicObject(984,2055.2000000,1594.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (88)
CreateDynamicObject(984,2055.2000000,1582.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (89)
CreateDynamicObject(984,2055.2000000,1569.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (90)
CreateDynamicObject(984,2055.2000000,1556.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (91)
CreateDynamicObject(984,2055.2000000,1550.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (92)
CreateDynamicObject(984,2059.5000000,1550.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (93)
CreateDynamicObject(984,2059.5000000,1562.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (94)
CreateDynamicObject(984,2059.5000000,1575.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (95)
CreateDynamicObject(984,2059.5000000,1588.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (96)
CreateDynamicObject(984,2059.5000000,1601.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (97)
CreateDynamicObject(984,2059.5000000,1614.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (98)
CreateDynamicObject(984,2059.5000000,1626.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (99)
CreateDynamicObject(984,2059.5000000,1633.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (100)
CreateDynamicObject(970,2057.3999000,1639.7000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (8)
CreateDynamicObject(970,2057.3999000,1543.8000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (9)
CreateDynamicObject(984,2055.3000000,1517.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (101)
CreateDynamicObject(984,2055.3000000,1504.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (102)
CreateDynamicObject(984,2055.3000000,1491.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (103)
CreateDynamicObject(984,2055.3000000,1479.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (104)
CreateDynamicObject(984,2055.3000000,1469.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (105)
CreateDynamicObject(984,2059.5000000,1469.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (106)
CreateDynamicObject(984,2059.5000000,1482.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (107)
CreateDynamicObject(984,2059.5000000,1495.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (108)
CreateDynamicObject(984,2059.5000000,1507.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (109)
CreateDynamicObject(984,2059.5000000,1517.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (110)
CreateDynamicObject(970,2057.3999000,1523.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (10)
CreateDynamicObject(970,2057.3999000,1463.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (11)
CreateDynamicObject(984,2055.2000000,1437.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (111)
CreateDynamicObject(984,2055.2000000,1424.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (112)
CreateDynamicObject(984,2055.2000000,1411.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (113)
CreateDynamicObject(984,2055.2000000,1399.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (114)
CreateDynamicObject(984,2055.2000000,1389.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (115)
CreateDynamicObject(984,2059.5000000,1389.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (116)
CreateDynamicObject(984,2059.5000000,1402.2000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (117)
CreateDynamicObject(984,2059.5000000,1415.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (118)
CreateDynamicObject(984,2059.5000000,1427.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (119)
CreateDynamicObject(984,2059.5000000,1437.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit2) (120)
CreateDynamicObject(970,2057.3999000,1443.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (12)
CreateDynamicObject(970,2057.3999000,1383.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (13)
CreateDynamicObject(982,2055.3000000,1351.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (1)
CreateDynamicObject(982,2055.3000000,1325.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (2)
CreateDynamicObject(982,2055.3000000,1299.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (3)
CreateDynamicObject(982,2055.3000000,1296.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (4)
CreateDynamicObject(982,2059.6001000,1296.6000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (5)
CreateDynamicObject(982,2059.6001000,1299.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (7)
CreateDynamicObject(982,2059.6001000,1325.4000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (6)
CreateDynamicObject(982,2059.6001000,1351.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (8)
CreateDynamicObject(970,2057.5000000,1363.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (14)
CreateDynamicObject(970,2057.5000000,1283.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (15)
CreateDynamicObject(982,2055.2000000,1251.0000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (9)
CreateDynamicObject(982,2055.2000000,1225.4000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (10)
CreateDynamicObject(982,2055.2000000,1215.8000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (11)
CreateDynamicObject(982,2059.6001000,1215.8000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (12)
CreateDynamicObject(982,2059.6001000,1225.4000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (13)
CreateDynamicObject(982,2059.6001000,1251.0000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (14)
CreateDynamicObject(970,2057.3999000,1263.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (16)
CreateDynamicObject(970,2057.3999000,1203.0000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (17)
CreateDynamicObject(982,2055.2000000,1171.0000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (15)
CreateDynamicObject(982,2055.2000000,1145.4000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (16)
CreateDynamicObject(982,2055.2000000,1119.8000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (17)
CreateDynamicObject(982,2055.2000000,1094.2000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (18)
CreateDynamicObject(982,2055.2000000,1068.6000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (19)
CreateDynamicObject(982,2055.2000000,1043.0000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (20)
CreateDynamicObject(982,2055.2000000,1017.4000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (21)
CreateDynamicObject(982,2055.2000000,996.5999800,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (22)
CreateDynamicObject(982,2059.6001000,996.5999800,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (23)
CreateDynamicObject(982,2059.6001000,1017.4000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (24)
CreateDynamicObject(982,2059.6001000,1043.0000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (25)
CreateDynamicObject(982,2059.6001000,1068.6000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (26)
CreateDynamicObject(982,2059.6001000,1094.2000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (27)
CreateDynamicObject(982,2059.6001000,1119.8000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (28)
CreateDynamicObject(982,2059.6001000,1145.4000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (29)
CreateDynamicObject(982,2059.6001000,1171.0000000,10.5000000,0.0000000,0.0000000,0.0000000); //object(fenceshit) (30)
CreateDynamicObject(970,2057.3999000,1183.8000000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (18)
CreateDynamicObject(970,2057.3999000,983.7999900,10.5000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (19)
CreateDynamicObject(982,2055.3000000,951.4000200,9.8000000,1.5000000,0.2500000,359.7430000); //object(fenceshit) (31)
CreateDynamicObject(982,2055.2000000,925.7999900,8.9000000,2.5000000,0.2470000,359.7380000); //object(fenceshit) (32)
CreateDynamicObject(982,2055.2000000,900.2000100,7.7000000,2.4990000,0.2470000,0.2360000); //object(fenceshit) (33)
CreateDynamicObject(982,2055.3000000,876.2000100,6.8000000,1.7490000,0.2470000,0.2400000); //object(fenceshit) (34)
CreateDynamicObject(982,2059.5000000,876.2000100,6.8000000,1.7470000,0.2420000,0.2360000); //object(fenceshit) (35)
CreateDynamicObject(982,2059.3999000,900.2000100,7.7000000,2.4940000,0.2470000,0.2360000); //object(fenceshit) (36)
CreateDynamicObject(982,2059.3999000,925.7999900,8.9000000,2.4990000,0.2470000,359.7360000); //object(fenceshit) (37)
CreateDynamicObject(982,2059.5000000,951.4000200,9.8000000,1.5000000,0.2470000,359.7420000); //object(fenceshit) (38)
CreateDynamicObject(970,2057.5000000,964.2000100,10.1000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (20)
CreateDynamicObject(970,2057.5000000,863.4000200,6.5000000,1.5000000,0.0000000,0.0000000); //object(fencesmallb) (21)
CreateDynamicObject(970,2137.3999000,2124.1001000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (22)
CreateDynamicObject(970,2137.3999000,2223.1001000,10.4000000,0.0000000,0.0000000,0.0000000); //object(fencesmallb) (23)
//=================================================================================================
 
 
    return 1;
}

public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++) SalvarDados(i); // Realizamos um loop na função Função SalvarDados para q salve todas as contas numa posivel queda do servidor
    mysql_close(IDConexao); // Aqui fechamos a conexão com o host
    return 1;
}

public OnPlayerConnect(playerid)
{
    GetPlayerName(playerid, PlayerInfo[playerid][pNome], 24); // Pegamos o nome do player somente uma vez quando se conectar e formatamos na variavel.
    GetPlayerIp(playerid, PlayerInfo[playerid][pIP], 26); // Mesma coisa no IP

    new Query[90]; // criamos uma variavel com 90 celulas
    mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Senha`, `ID` FROM `Contas` WHERE `Nome`='%s'", PlayerInfo[playerid][pNome]); // formatamos a Query selecionando SENHA e ID referente a tabela Contas Linha (NOME)
    mysql_tquery(IDConexao, Query, "VerificarContas", "i", playerid); // Faremos a consulta se a linha "Nome" existe sim ou não
    // Usaremos mysql_tquery para realizar a consulta na tabela e enviar o resultado para a callback.
    // o resultado sera enviado para callback VerificarContas
    SetPlayerColor(playerid, COLOR_WHITE);
    
	new roll = 0;
	while(roll < 100)
	{
    SendClientMessage(playerid, amarelo, "");
    roll++;
    }
    
    tempoon[playerid] = 0;
    
    SetTimerEx("contagemON", 900000, false, "i", playerid);
    
    
    return 1;
}

forward contagemON(playerid);
public contagemON(playerid)
{
tempoon[playerid] = 1;
return 1;
}

forward VerificarContas(playerid);
public VerificarContas(playerid)
{
    new Dialog[240]; // Variavel para as dialogs com 240 celulas necessarias

    if(cache_num_rows() > 0) // aqui o resultado da consulta da OnPlayerConnect
    {// Se a linha for maior que 1 "existir" ira chamar a dialog de login

        cache_get_value(0, "Senha", PlayerInfo[playerid][pSenha], 20); // Pegamos o valor da tabela e setamos a variavel pSenha que sera necessaria para o login

        format(Dialog, sizeof(Dialog),"{F8F8FF}Bem Vindo(a) Ao Servidor {058AFF}%s{F8F8FF}\n\nStatus: {1E90FF}Registrado{F8F8FF}\n\nDigite sua senha para Logar\n\n", PlayerInfo[playerid][pNome]);
        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Registro", Dialog, "Logar", "Cancelar");

        } else { // se a linha não existir sera chamada a dialog de registro

        format(Dialog, sizeof(Dialog),"{F8F8FF}Bem Vindo(a) Ao Servidor {058AFF}%s{F8F8FF}\n\nStatus: {058AFF}N/A Registrado{F8F8FF}\n\nDigite uma senha para Registrar\n\n", PlayerInfo[playerid][pNome]);
        ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", Dialog, "Registrar", "Cancelar");
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    SalvarDados(playerid); // Chamamos a função para salvar a conta do player que desconectar
    TextDrawHideForPlayer(playerid, Time), TextDrawHideForPlayer(playerid, Date);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    new string[128];
    new string1[128];
	format(string, sizeof(string), "(( Você foi morto pelo jogador %s. ))", ReturnName(killerid, 1));
	SendClientMessage(playerid, brancoclaro, string);
	
	if(playerid == killerid)
	{
	format(string1, sizeof(string1), "(( Você matou o jogador %s. ))", ReturnName(playerid, 1));
	SendClientMessage(killerid, brancoclaro, string1);
	}
    
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], 1958, 1343, 15, 220, 0, 0, 0, 0, 0, 0 );
    SpawnPlayer(playerid); // forçamos o player a spawnar nas cordenas acima com as infos setadas nas variaveis
    
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    new string[128];
    switch(dialogid) // usaremos um switch para as dialogs
    {
        case DIALOG_REGISTRO:
        {
            if(!response) return Kick(playerid); // se clicar em cancelar na dialog registro ira kickar o jogador

            if(strlen(inputtext) < 4 || strlen(inputtext) > 20) // se a senha tiver menos de 4 ou mais de 20 caracteres ira retornar a dialog
            {
                SendClientMessage(playerid, -1, "ERRO:{FFFFFF} A senha deve conter de 4 a 20 caracteres!");

                new Dialog[240]; // variavel da dialog registro
                format(Dialog, sizeof(Dialog),"{F8F8FF}Bem Vindo(a) Ao Servidor {058AFF}%s{F8F8FF}\n\nVocê não tem uma Conta registrada\n\nDigite uma senha para Registrar\n\nStatus: {058AFF}N/A Registrado{F8F8FF}\n\nIP: {058AFF}%s", PlayerInfo[playerid][pNome], PlayerInfo[playerid][pIP]);
                ShowPlayerDialog(playerid, DIALOG_REGISTRO, DIALOG_STYLE_PASSWORD, "Registro", Dialog, "Registrar", "Cancelar");

                } else { // se não conter entre 4 e 20 caracteres ira retornar ao registro

                new Query[240]; // variavel com 100 celulas para inserir as informações de registro na tabela
                mysql_format(IDConexao, Query, sizeof(Query), "INSERT INTO `Contas`(`Nome`, `Senha`) VALUES ('%s', '%s')", PlayerInfo[playerid][pNome], inputtext); // formatamos a query para inserir na tabela do banco de dados
                mysql_tquery(IDConexao, Query, "DadosRegistrados", "i", playerid); // fazemos a consulta e enviamos o resultado para a callback DadosRegistrados
                
                new Query1[240]; // variavel com 100 celulas para inserir as informações de registro na tabela
                mysql_format(IDConexao, Query1, sizeof(Query), "INSERT INTO `Armas`(`Arma1`) VALUES (0)"); // formatamos a query para inserir na tabela do banco de dados
                mysql_tquery(IDConexao, Query1, "DadosRegistrados", "i", playerid);
                // enviamos para a callback DadosRegistrados para fazer uma especia de  DEBUG, e tambem para darmos uma ID para a conta no banco de dados
                RegistrarDados(playerid); // chamamos a função RegistrarDados para adicionar os valores nas variaveis do player
            }
        }

        case DIALOG_LOGIN:
        {
            if(!response) return Kick(playerid); // se clicar em cancelar na dialog login ira kickar o jogador
            if(!strlen(inputtext)) // se não digitar nada ira retornar.
            {
            	SendClientMessage(playerid, -1, "ERRO:{FFFFFF} Você não digitou a senha !");
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Digite sua senha:", "Digite sua senha abaixo para logar-se", "Logar", "Voltar");
                return 1;
            }
            if(!strcmp(PlayerInfo[playerid][pSenha], inputtext, true, 20)) //comparamos a variavel coma senha do player com a senha digitada
            { // se a comparação for correta vamos realizar a consulta para adicionar os valores contidos na tabela para as variaveis do player.

                new Query[240];
                mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Contas` WHERE Nome='%s'", PlayerInfo[playerid][pNome]);
                mysql_tquery(IDConexao, Query, "CarregarContas", "d", playerid);
                // Formatamos a Query realizamos a consulta e enviamos o resultado para a callback CarregarContas

                } else {
                // comparação sem sucesso ::
                SendClientMessage(playerid, -1, "ERRO:{FFFFFF} Senha incorreta !");
                ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Digite sua senha:", "Digite sua senha abaixo para logar-se", "Logar", "Voltar");
            }
        }
		case DIALOG_AMMOCLAN:
		{
			new money;
	        if(response)//botão 1
	        {
	        money = GetPlayerMoney(playerid);

	        switch(listitem)//Item 0 da lista( é o primeiro da lista)
	        {
		        case 0:
		        {
		        if(money < 5) return SendClientMessage(playerid, vermelho, "Dinheiro insuficiente !");
		        GivePlayerMoney(playerid, -5);//Trocar quando ativar o anti cheat
				GivePlayerWeapon(playerid, 24, 80);
				}

				case 1:
				{
				if(money < 10) return SendClientMessage(playerid, vermelho, "Dinheiro insuficiente !");
				GivePlayerMoney(playerid, -10); //Trocar quando ativar o anti cheat
				GivePlayerWeapon(playerid, 31, 250);
				}

				case 2:
				{
				if(money < 15) return SendClientMessage(playerid, vermelho, "Dinheiro insuficiente !");
				GivePlayerMoney(playerid, -15);//Trocar quando ativar o anti cheat
				GivePlayerWeapon(playerid, 27, 100);
				}
			}
			}
		}
		case DIALOG_CRIARCASA:
		{
  			if(response)//botão 1
	        {
				switch(listitem)
				{
				case 0:
				{
				HouseID[playerid] = 1;

                Valor = 2000000;
		 		CriarCasa(playerid);
				format(string, sizeof(string), "Casa Criada! InteriorID %d Valor: $%d", IntID, Valor);
				SendClientMessage(playerid, azul_claro, string);
				counthouse++;
				}
				case 1:
				{
				HouseID[playerid] = 2;

                Valor = 600000;
		 		CriarCasa(playerid);
				format(string, sizeof(string), "Casa Criada! Valor: $%d", Valor);
				SendClientMessage(playerid, azul_claro, string);
				counthouse++;
				}
				case 2:
				{
				HouseID[playerid] = 3;

                Valor = 300000;
		 		CriarCasa(playerid);
				format(string, sizeof(string), "Casa Criada! Valor: $%d", Valor);
				SendClientMessage(playerid, azul_claro, string);
				counthouse++;
				}
				}
			}
		}
		case DIALOG_BINCO_COMPRAR:
		{
  			if(response)//botão 1
	        {
	        if(strval(inputtext) > 310 || strval(inputtext) < 1) return SendClientMessage(playerid, vermelho, "Você deve escolher uma skin entre 1 e 310.");
	        if(PlayerInfo[playerid][pDinheiro] < 300) return SendClientMessage(playerid, vermelho, "Você não tem dinheiro suficiente.");
	        GivePlayerMoney(playerid, -300);
	        SetPlayerSkin(playerid, strval(inputtext));
	        PlayerInfo[playerid][pSkin] = strval(inputtext);
	        }
		}
		case DIALOG_IMOBILIARIA:
		{
		new Query[300];
		new preco;
		new Float:picx,Float:picy,Float:picz;
  			if(response)//botão 1
	        {
				mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Casas` WHERE ID='%d'", strval(inputtext));
			 	mysql_query(IDConexao, Query);
			 	
				cache_get_value_int(0, "Valor", preco);
				
				if(strval(inputtext) > counthouse || strval(inputtext) < 1) return SendClientMessage(playerid, vermelho, "Essa casa não existe.");
				if(preco < 1) return SendClientMessage(playerid, vermelho, "Essa casa não esta a venda.");
				if(PlayerInfo[playerid][pSaldo] < preco) return SendClientMessage(playerid, vermelho, "Você não tem dinheiro suficiente na conta.");
				PlayerInfo[playerid][pSaldo] = PlayerInfo[playerid][pSaldo] - preco;
				
				    mysql_format(IDConexao, Query, sizeof(Query), "UPDATE `Casas` SET `Valor`=%d,`Dono`=%d WHERE `ID`=%d",
					0,
					PlayerInfo[playerid][pID],
					strval(inputtext));
					mysql_query(IDConexao, Query);
					
					Delete3DTextLabel(MyLabel[strval(inputtext)]);
					

					format(string, sizeof(string), "Dono: %s. N°: %d", PlayerInfo[playerid][pNome], strval(inputtext));
					
					 	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Casas` WHERE ID='%d'", strval(inputtext));
					 	mysql_query(IDConexao, Query);

						cache_get_value_float(0, "Picx", picx);
						cache_get_value_float(0, "Picy", picy);
						cache_get_value_float(0, "Picz", picz);
					
					MyLabel[strval(inputtext)] = Create3DTextLabel(string, amarelo, picx, picy, picz, 10.0, 0, 0);
				
				format(string, sizeof(string), "Você comprou a casa número %d.",strval(inputtext));
				SendClientMessage(playerid, verde, string);
				
	        }
		}
		case DIALOG_MEMBROS:
		{
  		new Query[300];
		new nivel;
		new pid;
		
		switch(orgnumber[playerid])
		{
			case 1:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
                    cache_get_value_int(0, "pID", pid);
	 		}
	 		case 2:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);
	 		}
	 		case 3:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);

	 		}
	 		case 4:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);
	 		}
	 		case 5:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);
	 		}
	 		case 6:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);
	 		}
	 		case 7:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);
	 		}
	 		case 8:
			{
					mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE pID='%d'", PlayerInfo[playerid][pID]);
				 	mysql_query(IDConexao, Query);
				 	cache_get_value_int(0, "Nivel", nivel);
				 	cache_get_value_int(0, "pID", pid);
	 		}
	 		
		}

			if(nivel == 5)
			{
 			if(response)//botão 1
	        {
		
				switch(listitem)//Item 0 da lista( é o primeiro da lista)
		        {
				case 0:
				{
				membros[playerid] = 1;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Pedir contas", "Confirma", "Cancelar");
				}
				case 1:
				{
                membros[playerid] = 2;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 2:
				{
                membros[playerid] = 3;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 3:
				{
                membros[playerid] = 4;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 4:
				{
                membros[playerid] = 5;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 5:
				{
				membros[playerid] = 6;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 6:
				{
                membros[playerid] = 7;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 7:
				{
                membros[playerid] = 8;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 8:
				{
                membros[playerid] = 9;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				case 9:
				{
                membros[playerid] = 10;
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_ACAO, DIALOG_STYLE_LIST, "Gerenciar organização", "Promover\nRebaixar\nDemitir", "Confirma", "Cancelar");
				}
				
		        }
	            }
			}
			else
			{
			if(response)//botão 1
	        {

				switch(listitem)//Item 0 da lista( é o primeiro da lista)
		        {
				case 0:
				{
				membros[playerid] = 1;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 1:
				{
				membros[playerid] = 2;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 2:
				{
				membros[playerid] = 3;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 3:
				{
				membros[playerid] = 4;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 4:
				{
				membros[playerid] = 5;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 5:
				{
				membros[playerid] = 6;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 6:
				{
				membros[playerid] = 7;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 7:
				{
				membros[playerid] = 8;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 8:
				{
				membros[playerid] = 9;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				case 9:
				{
				membros[playerid] = 10;
				switch(orgnumber[playerid])
				{
					case 1:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
		                    cache_get_value_int(0, "pID", pid);
			 		}
			 		case 2:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 3:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);

			 		}
			 		case 4:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 5:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 6:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 7:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}
			 		case 8:
					{
							mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
						 	mysql_query(IDConexao, Query);
						 	cache_get_value_int(0, "pID", pid);
			 		}

				}
				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você só pode gerenciar a si mesmo!");
				ShowPlayerDialog(playerid, DIALOG_MEMBROS_NORMAL, DIALOG_STYLE_LIST, "Gerenciar-se", "Pedir contas", "Confirma", "Cancelar");
				}
				
				}
			}
			}

		}
		
		case DIALOG_MEMBROS_NORMAL:
		{
		new Query1[300];
			if(response)
			{
				switch(listitem)
				{
					    case 0:
					    {
					        switch(orgnumber[playerid])
							{
							case 1:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 2:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 3:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 4:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 5:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 6:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 7:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
							case 8:
							{
	                        	PlayerInfo[playerid][pOrg] = 0;
								mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
								0,
								1,
								membros[playerid]);
								mysql_query(IDConexao, Query1);
								SalvarDados(playerid);
								SendClientMessage(playerid, azul_claro, "Você pediu contas da sua organização.");
							}
					    }
				    }
       			}
		    }
		}
		
		case DIALOG_MEMBROS_ACAO:
		{
		new Query[300];
		new Query1[300];
		new Query2[300];
		new nivel;
		new pid;
		new nome[20];
		new id;
		
		switch(orgnumber[playerid])
		{
		case 1:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 2:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 3:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 4:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 5:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 6:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 7:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		case 8:
		{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", membros[playerid]);
 		mysql_query(IDConexao, Query);
 		cache_get_value_int(0, "Nivel", nivel);
 		cache_get_value_int(0, "pID", pid);
		}
		
		}
 		
		mysql_format(IDConexao, Query2, sizeof(Query2), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
 		mysql_query(IDConexao, Query2);
 		cache_get_value(0, "Nome", nome, 20);
 		id = GetPlayerIdFromName(nome);
 		
 		switch(orgnumber[playerid])
		{
		case 1:
		{
		 	
			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}
				
				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
			
				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				
				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
			case 2:
			{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
			case 3:
			{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
				case 4:
		{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
	
				case 5:
		{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
				case 6:
		{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
				case 7:
		{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
    			}//case
				}//switch
				}
				case 8:
		{

			switch(membros[playerid])
			{
			case 1:
			{
					if(response)
					{
					switch(listitem)
					{
						case 0:
						{
							PlayerInfo[playerid][pOrg] = 0;
							mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
							0,
							1,
							1);
							mysql_query(IDConexao, Query1);
							SalvarDados(playerid);
							SendClientMessage(playerid, azul_claro, "Você pediu contas do seu cargo de Líder da organização.");
						}
					}
					}
				}

				case 2:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
     				}
			}
			case 3:
			{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

				}
				case 4:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}

				case 5:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 6:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 7:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 8:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 9:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}
				}
				case 10:
				{
					if(response)
					{
					if(pid == 0) return SendClientMessage(playerid, vermelho, "Não possui jogador nesse slot.");
					switch(listitem)
					{
						case 0:
						{
						if(nivel == 4) return SendClientMessage(playerid, vermelho, "Você não pode promover esse jogador mais do que o nivel 4.");
						nivel = nivel + 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi promovido em sua organização.");
						format(string, sizeof(string),"Você promoveu o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 1:
						{
						if(nivel == 1) return SendClientMessage(playerid, vermelho, "Você não pode rebaixar esse jogador menos do que o nivel 1.");
						nivel = nivel - 1;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `Nivel`=%d WHERE `ID`=%d",
						nivel,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi rebaixado em sua organização.");
						format(string, sizeof(string),"Você rebaixou o jogador(a) %s.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						}
						case 2:
						{
						PlayerInfo[id][pOrg] = 0;
						mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
						0,
						1,
						membros[playerid]);
						mysql_query(IDConexao, Query1);
						SendClientMessage(id, azul_claro, "Você foi demitido da organização.");
						format(string, sizeof(string),"Você demitiu o jogador(a) %s de sua organização.", ReturnName(id, 1));
						SendClientMessage(playerid, azul_claro, string);
						SalvarDados(id);
						}
						}
					}

    			}//case

				}//switch
				}
		}
	}

 }

    return 1;
}

forward DadosRegistrados(playerid);
public DadosRegistrados(playerid)
{
    PlayerWeap[playerid][pID] = cache_insert_id(); // Adicionamos o ID da conta do player
    PlayerInfo[playerid][pID] = cache_insert_id(); // Adicionamos o ID da conta do player
    printf("-> Nova conta registrada ID: %d", PlayerInfo[playerid][pID]); // Printf no samp server para informar que a conta foi registrada com sucesso
    return 1;
}

forward CarregarArmas(playerid);
public CarregarArmas(playerid)
{
	new Query[300];
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Armas` WHERE ID='%d'", PlayerInfo[playerid][pID]);
 	mysql_query(IDConexao, Query);
 	
    cache_get_value_int(0, "Arma1", PlayerWeap[playerid][pArma1]);
    cache_get_value_int(0, "Arma2", PlayerWeap[playerid][pArma2]);
    cache_get_value_int(0, "Arma3", PlayerWeap[playerid][pArma3]);
    cache_get_value_int(0, "Arma4", PlayerWeap[playerid][pArma4]);
    cache_get_value_int(0, "Arma5", PlayerWeap[playerid][pArma5]);
    cache_get_value_int(0, "Arma6", PlayerWeap[playerid][pArma6]);
    cache_get_value_int(0, "Arma7", PlayerWeap[playerid][pArma7]);
    cache_get_value_int(0, "Arma8", PlayerWeap[playerid][pArma8]);
    cache_get_value_int(0, "Arma9", PlayerWeap[playerid][pArma9]);
    cache_get_value_int(0, "Arma10", PlayerWeap[playerid][pArma10]);
    cache_get_value_int(0, "Arma11", PlayerWeap[playerid][pArma11]);
    cache_get_value_int(0, "Arma12", PlayerWeap[playerid][pArma12]);
    cache_get_value_int(0, "Ammo1", PlayerWeap[playerid][pAmmo1]);
    cache_get_value_int(0, "Ammo2", PlayerWeap[playerid][pAmmo2]);
    cache_get_value_int(0, "Ammo3", PlayerWeap[playerid][pAmmo3]);
    cache_get_value_int(0, "Ammo4", PlayerWeap[playerid][pAmmo4]);
    cache_get_value_int(0, "Ammo5", PlayerWeap[playerid][pAmmo5]);
    cache_get_value_int(0, "Ammo6", PlayerWeap[playerid][pAmmo6]);
    cache_get_value_int(0, "Ammo7", PlayerWeap[playerid][pAmmo7]);
    cache_get_value_int(0, "Ammo8", PlayerWeap[playerid][pAmmo8]);
    cache_get_value_int(0, "Ammo9", PlayerWeap[playerid][pAmmo9]);
    cache_get_value_int(0, "Ammo10", PlayerWeap[playerid][pAmmo10]);
    cache_get_value_int(0, "Ammo11", PlayerWeap[playerid][pAmmo11]);
    cache_get_value_int(0, "Ammo12", PlayerWeap[playerid][pAmmo12]);

	GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma1], PlayerWeap[playerid][pAmmo1]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma2], PlayerWeap[playerid][pAmmo2]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma3], PlayerWeap[playerid][pAmmo3]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma4], PlayerWeap[playerid][pAmmo4]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma5], PlayerWeap[playerid][pAmmo5]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma6], PlayerWeap[playerid][pAmmo6]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma7], PlayerWeap[playerid][pAmmo7]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma8], PlayerWeap[playerid][pAmmo8]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma9], PlayerWeap[playerid][pAmmo9]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma10], PlayerWeap[playerid][pAmmo10]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma11], PlayerWeap[playerid][pAmmo11]);
    GivePlayerWeapon(playerid, PlayerWeap[playerid][pArma12], PlayerWeap[playerid][pAmmo12]);
    printf("-> Armas Carregadas ID: %d", playerid);
	return 1;
}

forward CarregarContas(playerid);
public CarregarContas(playerid)
{ // Resultado da consulta do login, adicionamos os valores contidos na tabela para as variaveis do player
    cache_get_value_int(0, "ID", PlayerInfo[playerid][pID]);
    cache_get_value_int(0, "Admin", PlayerInfo[playerid][pAdmin]);
    cache_get_value_int(0, "Level", PlayerInfo[playerid][pLevel]);
    cache_get_value_int(0, "Matou", PlayerInfo[playerid][pMatou]);
    cache_get_value_int(0, "Morreu", PlayerInfo[playerid][pMorreu]);
    cache_get_value_int(0, "Skin", PlayerInfo[playerid][pSkin]);
    cache_get_value_int(0, "Dinheiro", PlayerInfo[playerid][pDinheiro]);
    cache_get_value_int(0, "X", PlayerInfo[playerid][pX]);
    cache_get_value_int(0, "Y", PlayerInfo[playerid][pY]);
    cache_get_value_int(0, "Z", PlayerInfo[playerid][pZ]);
    cache_get_value_int(0, "Rot", PlayerInfo[playerid][pRot]);
    cache_get_value_int(0, "Saldo", PlayerInfo[playerid][pSaldo]);
    cache_get_value_int(0, "Org", PlayerInfo[playerid][pOrg]);
    cache_get_value_int(0, "Health", PlayerInfo[playerid][pHealth]);
    cache_get_value_int(0, "Armour", PlayerInfo[playerid][pArmour]);
    cache_get_value_int(0, "Respeito", PlayerInfo[playerid][pResp]);
    cache_get_value_int(0, "Respeitoobj", PlayerInfo[playerid][pRespobj]);
    printf("-> Conta Carregada ID: %d", PlayerInfo[playerid][pID]);
    
    CarregarDados(playerid); // chamamos a função CarregarDados
    return 1;
}

forward CriarOrgs();
public CriarOrgs()
{

	for(new i = 1; i < 11; i++)
	{

		new Query[300];
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", i);
	 	mysql_query(IDConexao, Query);

	 	cache_get_value_int(0, "Nivel", OrgInfo[i][Nivel]);

		if(OrgInfo[i][Nivel] <= 0)
		{
			new Query1[350];
			mysql_format(IDConexao, Query1, sizeof(Query1), "INSERT INTO `pmlv`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query1);

			new Query3[350];
			mysql_format(IDConexao, Query3, sizeof(Query3), "INSERT INTO `pmls`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query3);

			new Query4[350];
			mysql_format(IDConexao, Query4, sizeof(Query4), "INSERT INTO `pc`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query4);

			new Query5[350];
			mysql_format(IDConexao, Query5, sizeof(Query5), "INSERT INTO `mafia1`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query5);

			new Query6[350];
			mysql_format(IDConexao, Query6, sizeof(Query6), "INSERT INTO `mafia2`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query6);

			new Query7[350];
			mysql_format(IDConexao, Query7, sizeof(Query7), "INSERT INTO `gangue1`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query7);

			new Query8[350];
			mysql_format(IDConexao, Query8, sizeof(Query8), "INSERT INTO `gangue2`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query8);

			new Query9[350];
			mysql_format(IDConexao, Query9, sizeof(Query9), "INSERT INTO `samu`(`Nivel`, `pID`) VALUES ('%d', '%d')",
			1,
			0);
			mysql_query(IDConexao, Query9);
		}
	}
	
	return 1;
}

forward CriarHQs();
public CriarHQs()
{

	for(new i = 1; i < 9; i++)
	{
		new Query[300];
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `HQ` WHERE VirtualW='%d'", i);
	 	mysql_query(IDConexao, Query);

	 	cache_get_value_int(0, "VirtualW", HQInfo[i][VirtualW]);

		if(HQInfo[i][VirtualW] <= 0)
		{
			new Query1[350];
			mysql_format(IDConexao, Query1, sizeof(Query1), "INSERT INTO `HQ`(`ID`) VALUES ('%d')",
			i);
			mysql_query(IDConexao, Query1);
		}
	}

	return 1;
}

forward ContarGasolina();
public ContarGasolina()
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	
	for(new i = 1; i < countcarros; i++)
	{
		GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
		if(engine == 1 && gasolina[i] > 0)
		{
		gasolina[i]--;
		}
		
		if(gasolina[i] == 0)
		{
		SetVehicleParamsEx(i, 0, lights, alarm, doors, bonnet, boot, objective);
		}
	}
	SetTimer("ContarGasolina", 90000, false);

}

stock ContarCasas()
{
	new Query[300];
	
	for(new i = 1;;i++)
	{
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Casas` WHERE ID='%d'", i);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "IntID", HouseInfo[i][pIntID]);
 	counthouse++;
 	if(HouseInfo[i][pIntID] <= 0)
 	{
 	break;
 	}
	}
	CarregarCasa();
}

stock RegistrarDados(playerid)
{  //Aqui adicionaremos os valores das variaveis que o player ira inicio no servidor
    PlayerInfo[playerid][pDinheiro] = 5000; // ou seja começara com 5000 reais
    PlayerInfo[playerid][pAdmin] = 0; // sem nivel de admin
    PlayerInfo[playerid][pLevel] = 1; // 1 level
    PlayerInfo[playerid][pSkin] = 0; // skin 0 CJ
    PlayerInfo[playerid][pMorreu] = 0; // ....
    PlayerInfo[playerid][pMatou] = 0; // ....
    PlayerInfo[playerid][pX] = 1958;
    PlayerInfo[playerid][pY] = 1343;
    PlayerInfo[playerid][pZ] = 15;
    PlayerInfo[playerid][pRot] = 260;
    PlayerInfo[playerid][pSaldo] = 0;
    PlayerInfo[playerid][pOrg] = 0;
    PlayerInfo[playerid][pHealth] = 50;
    PlayerInfo[playerid][pArmour] = 0;
    PlayerInfo[playerid][pResp] = 0;
    PlayerInfo[playerid][pRespobj] = 4;
    CarregarDados(playerid); //chamamos a função CarregarDados
    return 1;
}

stock CarregarDados(playerid)
{ // aqui carregaremos os ultimos dados das variaveis
    PlayerInfo[playerid][pLogado] = true;
    SetPlayerScore(playerid, PlayerInfo[playerid][pLevel]); // setamos o level
    GivePlayerMoney(playerid, PlayerInfo[playerid][pDinheiro]); // o dinheiro
    SetPlayerHealth(playerid, PlayerInfo[playerid][pHealth]);
    SetPlayerArmour(playerid, PlayerInfo[playerid][pArmour]);
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], PlayerInfo[playerid][pRot], 0, 0, 0, 0, 0, 0 );
    SpawnPlayer(playerid); // forçamos o player a spawnar nas cordenas acima com as infos setadas nas variaveis
    OnPlayerSpawn(playerid);
    printf("-> Dados Carregados ID: %d", PlayerInfo[playerid][pID]);
    return 1;
}

stock SalvarDados(playerid)
{
	new Float:x;
	new Float:y;
	new Float:z;
	new Float:Angle;
	new Float:health;
	new Float:armour;
	GetPlayerHealth(playerid, health);
	GetPlayerArmour(playerid, armour);
	GetPlayerFacingAngle(playerid, Angle);
	GetPlayerPos(playerid,x,y,z);
    //if(PlayerInfo[playerid][pLogado] == false) return 1; // se o player nao estiver logado não ira salvar nada
    PlayerInfo[playerid][pDinheiro] = GetPlayerMoney(playerid);
    new Query[350]; // variavel com 350 celulas para salvamento
    mysql_format(IDConexao, Query, sizeof(Query), "UPDATE `Contas` SET `Nome`='%s', `Level`=%d, `Admin`=%d, `Skin`=%d, `Matou`=%d, `Morreu`=%d, `X`=%f, `Y`=%f, `Z`=%f, `Rot`=%f,`Saldo`=%d,`Org`=%d,`Health`=%f,`Armour`=%f,`Respeito`=%d,`Respeitoobj`=%d, `Dinheiro`=%d WHERE `ID`=%d",
    PlayerInfo[playerid][pNome],
    PlayerInfo[playerid][pLevel],
    PlayerInfo[playerid][pAdmin],
    PlayerInfo[playerid][pSkin],
    PlayerInfo[playerid][pMatou],
    PlayerInfo[playerid][pMorreu],
    x,
    y,
    z,
    Angle,
    PlayerInfo[playerid][pSaldo],
    PlayerInfo[playerid][pOrg],
    health,
    armour,
    PlayerInfo[playerid][pResp],
    PlayerInfo[playerid][pRespobj],
    PlayerInfo[playerid][pDinheiro],
    PlayerInfo[playerid][pID]);

    // formatamos a Query referente a ID da conta (WHERE `ID`=%d) e realizaremos a consulta para atualizar os dados no banco de dados
    mysql_tquery(IDConexao, Query, "DadosSalvos","d", playerid); // consulta, e enviamos o resultado para a callback DadosSalvos para um DEBUG
    
    new Arma1, Arma2, Arma3, Arma4, Arma5, Arma6, Arma7, Arma8, Arma9, Arma10, Arma11, Arma12, Ammo1, Ammo2, Ammo3, Ammo4, Ammo5, Ammo6, Ammo7, Ammo8, Ammo9, Ammo10, Ammo11, Ammo12;

    GetPlayerWeaponData(playerid, 0, Arma1, Ammo1);
    GetPlayerWeaponData(playerid, 1, Arma2, Ammo2);
    GetPlayerWeaponData(playerid, 2, Arma3, Ammo3);
    GetPlayerWeaponData(playerid, 3, Arma4, Ammo4);
    GetPlayerWeaponData(playerid, 4, Arma5, Ammo5);
    GetPlayerWeaponData(playerid, 5, Arma6, Ammo6);
    GetPlayerWeaponData(playerid, 6, Arma7, Ammo7);
    GetPlayerWeaponData(playerid, 7, Arma8, Ammo8);
    GetPlayerWeaponData(playerid, 8, Arma9, Ammo9);
    GetPlayerWeaponData(playerid, 9, Arma10, Ammo10);
    GetPlayerWeaponData(playerid, 10, Arma11, Ammo11);
    GetPlayerWeaponData(playerid, 11, Arma12, Ammo12);
    
    new Query1[350]; // variavel com 350 celulas para salvamento
    mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `Armas` SET `Arma1`='%d', `Arma2`='%d',`Arma3`='%d',`Arma4`='%d',`Arma5`='%d',`Arma6`='%d',`Arma7`='%d',`Arma8`='%d',`Arma9`='%d',`Arma10`='%d',`Arma11`='%d',`Arma12`='%d' WHERE `ID`=%d",
	Arma1,
	Arma2,
	Arma3,
	Arma4,
	Arma5,
	Arma6,
	Arma7,
	Arma8,
	Arma9,
	Arma10,
	Arma11,
	Arma12,
	PlayerInfo[playerid][pID]);
	mysql_query(IDConexao, Query1);
	new Query2[350];
    mysql_format(IDConexao, Query2, sizeof(Query2), "UPDATE `Armas` SET `Ammo1`='%d',`Ammo2`='%d',`Ammo3`='%d',`Ammo4`='%d',`Ammo5`='%d',`Ammo6`='%d',`Ammo7`='%d',`Ammo8`='%d',`Ammo9`='%d',`Ammo10`='%d',`Ammo11`='%d',`Ammo12`='%d' WHERE `ID`=%d",
	Ammo1,
	Ammo2,
	Ammo3,
	Ammo4,
	Ammo5,
	Ammo6,
	Ammo7,
	Ammo8,
	Ammo9,
	Ammo10,
	Ammo11,
	Ammo12,
	PlayerInfo[playerid][pID]);
    mysql_query(IDConexao, Query2);
/*
    PlayerInfo[playerid][pLevel] = 0; // resetamos as variaveis.
    PlayerInfo[playerid][pAdmin] = 0;
    PlayerInfo[playerid][pMatou] = 0;
    PlayerInfo[playerid][pMorreu] = 0;
    PlayerInfo[playerid][pDinheiro] = 0;*/
    PlayerInfo[playerid][pLogado] = false;
    return 1;
}

stock CriarCarro(playerid)
{
		new Query[100]; // variavel com 100 celulas para inserir as informações de registro na tabela
    	mysql_format(IDConexao, Query, sizeof(Query), "INSERT INTO `Carros`(`Model`, `Dono`) VALUES ('%d', '%d')", buycar, PlayerInfo[playerid][pID]);
   	 	printf("-> Carro criado");
   	 	mysql_tquery(IDConexao, Query, "DadosSalvos","d", playerid);
}

stock CarregarCarros()
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
	new Query[70];

	
	for(new i = 1;;i++)
	{
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Carros` WHERE ID='%d'", i);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Model", VehicleInfo[i][pModel]);
 	countcarros++;
 	if(VehicleInfo[i][pModel] < 400)
 	{
 	break;
 	}
	}
	
	for(new i = 1; i < countcarros; i++)
	{
 	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Carros` WHERE ID='%d'", i);
 	mysql_query(IDConexao, Query);

 	cache_get_value_int(0, "Model", VehicleInfo[i][pModel]);
	cache_get_value_float(0, "X", VehicleInfo[i][pX]);
	cache_get_value_float(0, "Y", VehicleInfo[i][pY]);
	cache_get_value_float(0, "Z", VehicleInfo[i][pZ]);
	cache_get_value_float(0, "Rot", VehicleInfo[i][pRot]);

	printf("-> '%d','%f','%f','%f'", VehicleInfo[i][pModel], VehicleInfo[i][pX], VehicleInfo[i][pY], VehicleInfo[i][pZ], VehicleInfo[i][pRot]);

	if(VehicleInfo[i][pModel] >= 400)
	{
	CreateVehicle(VehicleInfo[i][pModel], VehicleInfo[i][pX], VehicleInfo[i][pY], VehicleInfo[i][pZ], VehicleInfo[i][pRot], 255, 255, 0);
	
	GetVehicleParamsEx(i, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(i, 0, lights, alarm, doors, bonnet, boot, objective);
	
	gasolina[i] = 100;
	
	new string[100];
	format(string, sizeof(string), "{0000FF}%d", i);
	SetVehicleNumberPlate(i, string);
	printf("-> Carro Criado");
	}
	}
	return 1;
}



stock SalvarCarro(playerid)
{
	new vid;
	new string[30];
    vid = GetPlayerVehicleID(playerid);
    if(vid == 0)
    {
	format(string, sizeof(string), "Você não esta em um carro.");
	return SendClientMessageToAll(vermelho, string);
	}
	new Float:x, Float:y, Float:z;
	new Float:zr;
	GetVehiclePos(vid, x, y, z);
	GetVehicleZAngle(vid, zr);
/*	switch(GetVehiclePaintjob(vid))
	{
	case 1:
	{
	VehicleInfo[vid][pPaintjob] = 1;
	}
	case 2:
	{
	VehicleInfo[vid][pPaintjob] = 2;
	}
	case 3:
	{
	VehicleInfo[vid][pPaintjob] = 3;
	}
	}*/
    new Query[100]; // variavel com 350 celulas para salvamento
    mysql_format(IDConexao, Query, sizeof(Query), "UPDATE `Carros` SET `X`=%f, `Y`=%f,`Z`=%f,`Rot`=%f WHERE `ID`=%d",
	x,
	y,
	z,
	zr,
	vid);
	printf("-> Carro salvo");
	mysql_query(IDConexao, Query);
//	mysql_tquery(IDConexao, Query, "DadosSalvos","d", vid);
    return 1;
}

stock GetVehicleSpeed(vehicleid)
{
    new
        Float:x,
        Float:y,
        Float:z,
        vel;
    GetVehicleVelocity( vehicleid, x, y, z );
    vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 );           // KM/H
//  vel = floatround( floatsqroot( x*x + y*y + z*z ) * 180 / MPH_KMH ); // Mph
    return vel;
}

stock CarregarLojas()
{


AddStaticPickup(1239, 2, 2101.9924, 2257.4414, 11.0234, -1);//BincoLV(Avenida)
AddStaticPickup(1239, 2, 1656.8474, 1733.3461, 10.8281, -1);//BincoLV(HP)
AddStaticPickup(1239, 2, 2244.3831, -1665.4498, 15.4766, -1);//BincoLS
AddStaticPickup(1239, 2, 207.6284, -111.0890, 1005.1328, -1);//InteriorBinco
AddStaticPickup(1239, 2, 207.7381, -100.4321, 1005.2578, -1);//InteriorBincoComprar

AddStaticPickup(1239, 2, 2364.5852, 2377.6272, 10.8203, -1);//Imobiliaria
AddStaticPickup(1239, 2, 1494.4463,1303.7946,1093.2891, -1);//ImobiliariaInterior
AddStaticPickup(1239, 2, 1490.4615,1305.6903,1093.2964, -1);//ImobiliariaMesa




//=====================================

Create3DTextLabel("/comprar", amarelo, 207.7381, -100.4321, 1005.2578, 10.0, 1, 0);//Binco
Create3DTextLabel("/comprar", amarelo, 207.7381, -100.4321, 1005.2578, 10.0, 2, 0);//Binco
Create3DTextLabel("/comprar", amarelo, 207.7381, -100.4321, 1005.2578, 10.0, 3, 0);//Binco

Create3DTextLabel("/comprar", amarelo, 1490.4615,1305.6903,1093.2964, 10.0, 1, 0);//ImobiliariaMesa

}

stock CarregarCasa()
{
    new Query[50];
	for(new i = 1; i < counthouse; i++)
	{
 	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Casas` WHERE ID='%d'", i);
 	mysql_query(IDConexao, Query);

	cache_get_value_float(0, "Picx", HouseInfo[i][pPicx]);
	cache_get_value_float(0, "Picy", HouseInfo[i][pPicy]);
	cache_get_value_float(0, "Picz", HouseInfo[i][pPicz]);
	cache_get_value_int(0, "Dono", HouseInfo[i][pDono]);
	cache_get_value_int(0, "Valor", HouseInfo[i][pValor]);


 	new string1[50];
 	new nome[20];
	
	if(HouseInfo[i][pDono] == 0)
 	{
 	format(string1, sizeof(string1), "Dono: Nenhum. N°: %d\nValor: $%d", i, HouseInfo[i][pValor]);
	}
	else
	{
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Contas` WHERE ID='%d'", HouseInfo[i][pDono]);
 	mysql_query(IDConexao, Query);
 	cache_get_value(0, "Nome", nome, 20);
	format(string1, sizeof(string1), "Dono: %s. N°: %d", nome, i);
	}
	
	MyLabel[i] = Create3DTextLabel(string1, amarelo, HouseInfo[i][pPicx], HouseInfo[i][pPicy], HouseInfo[i][pPicz], 10.0, 0, 0);
	
    AddStaticPickup(1239, 2, HouseInfo[i][pPicx], HouseInfo[i][pPicy], HouseInfo[i][pPicz], -1);
    printf("-> Carregar Casas");
   	printf("-> '%f','%f','%f'", HouseInfo[i][pPicx], HouseInfo[i][pPicy], HouseInfo[i][pPicz]);
    }
    return 1;
}

stock SetarHQ(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	AddStaticPickup(1239, 2, x, y, z, 0);
	
	new Float:intx, Float:inty, Float:intz;

	switch(HouseID[playerid])
	{
	case 1:
	{
	intx = 1260.64;
	inty = -785.37;
	intz = 1091.91;
	IntID = 5;
	}
	case 2:
	{
	intx = 235.34;
	inty = 1186.68;
	intz = 1080.26;
	IntID = 3;
	}
	case 3:
	{
	intx = -42.59;
	inty = 1405.47;
	intz = 1084.43;
	IntID = 8;
	}
	}

	new Query[350]; // variavel com 100 celulas para inserir as informações de registro na tabela
	mysql_format(IDConexao, Query, sizeof(Query), "UPDATE `HQ` SET `IntID`=%d, `Picx`=%f, `Picy`=%f,`Picz`=%f,`Intx`=%f,`Inty`=%f,`Intz`=%f,`cofrex`=%f,`cofrey`=%f,`cofrez`=%f WHERE `ID`=%d",
	IntID,
	x,
	y,
	z,
	intx,
	inty,
	intz,
	0,
	0,
	0,
	hqid[playerid]);
	mysql_query(IDConexao, Query);
	return 1;
}

stock SetarCofre(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);

	new Query[350]; // variavel com 100 celulas para inserir as informações de registro na tabela
	mysql_format(IDConexao, Query, sizeof(Query), "UPDATE `HQ` SET `cofrex`=%f,`cofrey`=%f,`cofrez`=%f WHERE `ID`=%d",
	x,
	y,
	z,
	hqid[playerid]);
	mysql_query(IDConexao, Query);
	return 1;
}

stock CarregarHQs()
{
	new Query[50];
	for(new i = 1; i < 9; i++)
	{
 	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `HQ` WHERE ID='%d'", i);
 	mysql_query(IDConexao, Query);

	cache_get_value_float(0, "Picx", HQInfo[i][pPicx]);
	cache_get_value_float(0, "Picy", HQInfo[i][pPicy]);
	cache_get_value_float(0, "Picz", HQInfo[i][pPicz]);
	
	AddStaticPickup(1239, 2, HQInfo[i][pPicx], HQInfo[i][pPicy], HQInfo[i][pPicz], -1);
	}
	return 1;
}

stock CriarCasa(playerid)
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	AddStaticPickup(1239, 2, x, y, z, 0);

 	new string[50];
	format(string, sizeof(string), "Dono: Nenhum. N°: %d\nValor: $%d", counthouse, Valor);
	Create3DTextLabel(string, amarelo, x, y, z, 10.0, 0, 0);
	
	new Float:intx, Float:inty, Float:intz;
	
	switch(HouseID[playerid])
	{
	case 1:
	{
	intx = 1260.64;
	inty = -785.37;
	intz = 1091.91;
	IntID = 5;
	}
	case 2:
	{
	intx = 235.34;
	inty = 1186.68;
	intz = 1080.26;
	IntID = 3;
	}
	case 3:
	{
	intx = -42.59;
	inty = 1405.47;
	intz = 1084.43;
	IntID = 8;
	}
	}

	new Query[350]; // variavel com 100 celulas para inserir as informações de registro na tabela
	mysql_format(IDConexao, Query, sizeof(Query), "INSERT INTO `Casas`(`IntID`, `Picx`, `Picy`,`Picz`,`Intx`,`Inty`,`Intz`,`Valor`,`Dono`) VALUES ('%d', '%f','%f', '%f','%f', '%f','%f','%d', '%d')",
	IntID,
	x,
	y,
	z,
	intx,
	inty,
	intz,
	Valor,
	0);
	mysql_query(IDConexao, Query);
	
 	new Query1[350]; // variavel com 350 celulas para salvamento
    mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `Casas` SET `VirtualW`=%d WHERE `ID`=%d",
	counthouse,
	counthouse);
	
	printf("-> Carro salvo");
	mysql_query(IDConexao, Query1);

	printf("-> Casa criada");
	return 1;
}

ReturnName(playerid, underscore=1)
{
	static
	    name[MAX_PLAYER_NAME + 1];

	GetPlayerName(playerid, name, sizeof(name));

	if (!underscore) {
	    for (new i = 0, len = strlen(name); i < len; i ++) {
	        if (name[i] == '_') name[i] = ' ';
		}
	}

	return name;
}

stock CheckCaixa(playerid)
{
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 2107.3420, 896.7759, 11.1797)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 2631.8035, 1129.6782, 11.1797)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 2140.4182, 2733.8657, 11.1763)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1603.1667, 2229.1882, 11.0625)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 666.9672, 1721.0043, 7.1875)) nocaixa[playerid] = 1;

	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1013.7048, -928.9415, 42.3281)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 735.4331, -1440.4490, 13.5391)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1928.5812, -1783.6726, 13.5469)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 666.3273, -552.2776, 16.3359)) nocaixa[playerid] = 1;
	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1389.2513, 462.8870, 20.1914)) nocaixa[playerid] = 1;
	return 1;
}

stock Comprar(playerid)
{
    if(IsPlayerInRangeOfPoint(playerid, 2.0, 207.7381, -100.4321, 1005.2578))//BINCO
    {
  		ShowPlayerDialog(playerid, DIALOG_BINCO_COMPRAR, DIALOG_STYLE_INPUT, "Binco",
		"Escolha o ID da Skin que deseja. Custo: $300.",
		"Comprar", "Cancelar");
    }
	else if(IsPlayerInRangeOfPoint(playerid, 2.0, 1490.4615,1305.6903,1093.2964))//Imobiliaria
	{
		ShowPlayerDialog(playerid, DIALOG_IMOBILIARIA, DIALOG_STYLE_INPUT, "Imobiliaria",
		"Coloque o numero da casa que deseja comprar.",
		"Comprar", "Cancelar");
	}
    else
    {
    SendClientMessage(playerid, vermelho, "Não tem o que comprar aqui.");
    }
}


stock GetPlayerIdFromName(playername[])
{
  for(new i = 0; i <= MAX_PLAYERS; i++)
  {
    if(IsPlayerConnected(i))
    {
      new playername2[MAX_PLAYER_NAME];
      GetPlayerName(i, playername2, sizeof(playername2));
      if(strcmp(playername2, playername, true, strlen(playername)) == 0)
      {
        return i;
      }
    }
  }
  return INVALID_PLAYER_ID;
}

SendPlayerToPlayer(playerid, targetid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;

	GetPlayerPos(targetid, x, y, z);

	if (IsPlayerInAnyVehicle(playerid))
	{
	    SetVehiclePos(GetPlayerVehicleID(playerid), x, y + 2, z);
		LinkVehicleToInterior(GetPlayerVehicleID(playerid), GetPlayerInterior(targetid));
	}
	else
		SetPlayerPos(playerid, x + 1, y, z);

	SetPlayerInterior(playerid, GetPlayerInterior(targetid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

/*	PlayerData[playerid][pHouse] = PlayerData[targetid][pHouse];
	PlayerData[playerid][pBusiness] = PlayerData[targetid][pBusiness];
	PlayerData[playerid][pEntrance] = PlayerData[targetid][pEntrance];
	PlayerData[playerid][pHospitalInt]  = PlayerData[targetid][pHospitalInt];*/
}

SendCarToPlayer(vehicleid, playerid)
{
	new
	    Float:x,
	    Float:y,
	    Float:z;
	    
	    GetPlayerPos(playerid, x, y, z);
        SetVehiclePos(vehicleid, x, y + 2, z);
}

stock RespawnPlayer(playerid)
{
	if (IsPlayerInAnyVehicle(playerid))
	{
        new
		    Float:x,
		    Float:y,
	    	Float:z;

	    GetPlayerPos(playerid, x, y, z);
	    SetPlayerPos(playerid, x, y, z + 1);
	}
	SpawnPlayer(playerid);
//	SetDefaultSpawn(playerid);
	return 1;
}

stock GetClosestVehicle(playerid)
{
	new Float:x, Float:y, Float:z;
	new Float:dist, Float:closedist=5, closeveh;
	for(new i=1; i < MAX_VEHICLES; i++)
	{
		if(GetVehiclePos(i, x, y, z))
		{
			dist = GetPlayerDistanceFromPoint(playerid, x, y, z);
			if(dist < closedist)
			{
				closedist = dist;
				closeveh = i;
			}
		}
	}
	return closeveh;
}

forward ApagarFarol(vehicleid);
public ApagarFarol(vehicleid)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, 0, alarm, doors, bonnet, boot, objective);
	return 1;
}

//==========================CHAT POR DISTANCIA=========================================
//==========================CHAT POR DISTANCIA=========================================
//==========================CHAT POR DISTANCIA=========================================
ProxDetector(Float:radi, playerid, string[], col1, col2, col3, col4, col5)
{
    new Float:pPositionX[3], Float:oPositionX[3];
    GetPlayerPos(playerid, pPositionX[0], pPositionX[1], pPositionX[2]);
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	if(GetPlayerVirtualWorld(playerid) == GetPlayerVirtualWorld(i))
	{
        GetPlayerPos(i, oPositionX[0], oPositionX[1], oPositionX[2]);
        if(IsPlayerInRangeOfPoint(i, radi / 16, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col1, string); }
        else if(IsPlayerInRangeOfPoint(i, radi / 8, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col2, string); }
        else if(IsPlayerInRangeOfPoint(i, radi / 4, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col3, string); }
        else if(IsPlayerInRangeOfPoint(i, radi / 2, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col4, string); }
        else if(IsPlayerInRangeOfPoint(i, radi, pPositionX[0], pPositionX[1], pPositionX[2])) { SendClientMessage(i, col5, string); }
        }
    }
    return 1;
}

public OnPlayerText(playerid, text[])
{
    new pname[MAX_PLAYER_NAME], str[128];//reduce it if you want
    GetPlayerName(playerid, pname, sizeof(pname));
  //  strreplace(pname, '_', ' ');
    format(str, sizeof(str), "%s diz: %s", pname, text);//Appearance of the text submitted by a nearby player.
    ProxDetector(10.0, playerid, str, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    return 0;//So that the text is not submitted regularly.
    
    
}

//======================================================================================================
//======================================================================================================
//======================================================================================================

public OnPlayerSpawn(playerid)
{
	TogglePlayerControllable(playerid, 0);
	SendClientMessage(playerid, amarelo, "Aguarde 3 segundos.");
	SetTimerEx("DescongelarSpawn", 3000, false, "i", playerid);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	SetPlayerColor(playerid, COLOR_WHITE);
	CarregarArmas(playerid);
	TextDrawShowForPlayer(playerid, Time), TextDrawShowForPlayer(playerid, Date);
	return 1;
}


forward Overlays();
public Overlays()
{
        new string[256],year,month,day,hours,minutes,seconds;
        getdate(year, month, day), gettime(hours, minutes, seconds);
        format(string, sizeof string, "%d/%s%d/%s%d", day, ((month < 10) ? ("0") : ("")), month, (year < 10) ? ("0") : (""), year);
        TextDrawSetString(Date, string);
        format(string, sizeof string, "%s%d:%s%d:%s%d", (hours < 10) ? ("0") : (""), hours, (minutes < 10) ? ("0") : (""), minutes, (seconds < 10) ? ("0") : (""), seconds);
        TextDrawSetString(Time, string);
        
        
}

forward DescongelarSpawn(playerid);
public DescongelarSpawn(playerid)
{
	TogglePlayerControllable(playerid, 1);
	SetPlayerSkin(playerid, PlayerInfo[playerid][pSkin]);
	return 1;
}

forward DadosSalvos(playerid);
public DadosSalvos(playerid) return printf("-> Conta salva ID: %d", PlayerInfo[playerid][pID]);

forward SincronizarTempo();
public SincronizarTempo()
{
	new horaa, minuu, secc;
	new tempocerto;
	gettime(horaa, minuu, secc);
	TempoSec = 60000;
	tempocerto = secc * 1000;
	TempoSec = TempoSec - tempocerto;
	SetTimer("PayDay", TempoSec, false);
	return 1;
}

forward PayDay();
public PayDay()
{
	new stringsaldo[100];
    printf("-> Hora Atualizada");
	new horaa, minuu, secc;
	gettime(horaa, minuu, secc);
	
	if(minuu == 0 || Forcepd == 1)
	{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
		SalvarDados(i);
		format(stringsaldo, sizeof(stringsaldo), "Agora são %d:00 horas",horaa);
		SendClientMessage(i, amarelo, stringsaldo);
		if(tempoon[i] == 0)
		{
		format(stringsaldo, sizeof(stringsaldo), "Você não jogou tempo suficiente para receber seu pagamento.");
		SendClientMessage(i, amarelo, stringsaldo);
		}
		else
		{
		PlayerInfo[i][pResp]++;
		CheckLvl(i);
		SetClima();
		PlayerPlaySound(i, 1068, 0, 0, 0);
		SetTimer("Pararmusica", 3000, false);
		}
		
	}
	}
	
	if(Forcepd == 0)
	{
	SincronizarTempo();
	}
	
	Forcepd = 0;
	return 1;
}

forward Pararmusica();
public Pararmusica()
{
	for(new i = 0; i < MAX_PLAYERS; i++)
	{
	PlayerPlaySound(i, 0, 0, 0, 0);
	}
	return 1;
}

forward CheckLvl(playerid);
public CheckLvl(playerid)
{
	if(PlayerInfo[playerid][pResp] == PlayerInfo[playerid][pRespobj])
	{
	LevelUp(playerid);
	}
	return 1;
}

forward LevelUp(playerid);
public LevelUp(playerid)
{
    PlayerInfo[playerid][pResp] = 0;
    PlayerInfo[playerid][pLevel]++;
    if(PlayerInfo[playerid][pLevel] == 2)
    {
    PlayerInfo[playerid][pRespobj] = 6;
    }
    else
    {
    PlayerInfo[playerid][pRespobj] = PlayerInfo[playerid][pRespobj] + 6;
    }
    SincronizarTempo();
    return 1;
}

forward GMX();
public GMX()
{
	GameModeExit();
	return 1;
}

forward SetClima();
public SetClima()
{
	new horaa, minuu, secc;
	gettime(horaa, minuu, secc);
	switch(horaa)
	{
	    case 1:
	    {
	    SetWeather(91);
	    }
	    case 2:
	    {
	    SetWeather(91);
	    }
	    case 3:
	    {
	    SetWeather(91);
	    }
	    case 4:
	    {
	    SetWeather(61);
	    }
	    case 5:
	    {
	    SetWeather(50);
	    }
	    case 6:
	    {
	    SetWeather(51);
	    }
	    case 7:
	    {
	    SetWeather(51);
	    }
	    case 8:
	    {
	    SetWeather(51);
	    }
	    case 9:
	    {
	    SetWeather(2);
	    }
	    case 10:
	    {
	    SetWeather(2);
	    }
	    case 11:
	    {
	    SetWeather(2);
	    }
	    case 12:
	    {
	    SetWeather(1);
	    }
	    case 13:
	    {
	    SetWeather(10);
	    }
	    case 14:
	    {
	    SetWeather(5);
	    }
	    case 16:
	    {
	    SetWeather(40);
	    }
	    case 17:
	    {
	    SetWeather(46);
	    }
	    case 18:
	    {
	    SetWeather(75);
	    }
	    case 19:
	    {
	    SetWeather(75);
	    }
	    case 20:
	    {
	    SetWeather(80);
	    }
	    case 21:
	    {
	    SetWeather(80);
	    }
	    case 22:
	    {
	    SetWeather(91);
	    }
	    case 23:
	    {
	    SetWeather(91);
	    }
	    case 0:
	    {
	    SetWeather(91);
	    }
	}
	return 1;
}
/*
forward OnCheatDetected(playerid, ip_address[], type, code);
public OnCheatDetected(playerid, ip_address[], type, code)
{
	new nome[32];
	switch(code)
	{
	case 1:
	{
	nome = "AirBreak";
	}
	case 2:
	{
	nome = "AirBreak";
	}
	case 3:
	{
	nome = "Teleporte(A pé)";
	}
	case 4:
	{
	nome = "Teleporte(Carro)";
	}
	case 5:
	{
	nome = "Teleporte(Entre veículos)";
	}
	case 6:
	{
	nome = "Teleporte(Veículo-Jogador)";
	}
	case 7:
	{
	nome = "FlyHack";
	}
	case 8:
	{
	nome = "FlyHack(Carro)";
	}
	case 9:
	{
	nome = "SpeedHack(A pé)";
	}
	case 10:
	{
	nome = "SpeedHack(Carro)";
	}
	case 11:
	{
	nome = "Vida(Carro)";
	}
	case 12:
	{
	nome = "Vida";
	}
	case 13:
	{
	nome = "Colete";
	}
	case 14:
	{
	nome = "Dinheiro";
	}
	case 15:
	{
	nome = "Armas";
	}
	case 16:
	{
	nome = "AmmoHack(Adicionando)";
	}
	case 17:
	{
	nome = "AmmoHack(Infinito)";
	}
	case 18:
	{
	nome = "AnimEspeciais";
	}
	case 19:
	{
	nome = "GodMode(Jogador)";
	}
	case 20:
	{
	nome = "GodMode(Veículos)";
	}
	case 21:
	{
	nome = "Invisivel";
	}
	case 22:
	{
	nome = "Lag compensation";
	}
	case 23:
	{
	nome = "Tuning(Veículos)";
	}
	case 24:
	{
	nome = "Parkour mod";
	}
	case 25:
	{
	nome = "Volta instantanea";
	}
	case 26:
	{
	nome = "Rapid fire";
	}
	case 27:
	{
	nome = "FakeSpawn";
	}
	case 28:
	{
	nome = "FakeKill";
	}
	case 29:
	{
	nome = "Pro Aim(Aimbot)";
	}
	case 30:
	{
	nome = "CJ Run";
	}
	case 31:
	{
	nome = "CarShot";
	}
	case 32:
	{
	nome = "CarJack";
	}
	case 33:
	{
	nome = "Auto-Descongelar";
	}
	case 34:
	{
	nome = "Fake AFK";
	}
	case 35:
	{
	nome = "Aimbot";
	}
	case 36:
	{
	nome = "Fake NPC";
	}
	case 37:
	{
	nome = "Auto reconnect";
	}
	case 38:
	{
	nome = "Ping alto";
	}
	case 39:
	{
	nome = "Dialog";
	}
	case 40:
	{
	nome = "Usando Sandbox";
	}
	case 41:
	{
	nome = "Versão invalida(SA-MP)";
	}
	case 42:
	{
	nome = "Rcon hack";
	}
	case 43:
	{
	nome = "Tuning(Crasher)";
	}
	case 44:
	{
	nome = "Assento invalido(Crasher)";
	}
	case 45:
	{
	nome = "Dialog(Crasher)";
	}
	case 46:
	{
	nome = "Aplicação de Obj(Crasher)";
	}
	case 47:
	{
	nome = "Armas(Crasher)";
	}
	case 48:
	{
	nome = "Flood de conexão";
	}
	case 49:
	{
	nome = "Flood de callbacks";
	}
	case 50:
	{
	nome = "Flood de troca de acento";
	}
	case 51:
	{
	nome = "DDoS";
	}
	case 52:
	{
	nome = "NOP";
	}
	}

   		new string[128];
   		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		if (PlayerInfo[i][pAdmin] > 1)
		{
		format(string, sizeof(string), "[ANTI-CHEAT] O jogador %s [ID: %d] esta suspeito de cheat. Tipo: %s [ID: %d].", ReturnName(playerid, 1), playerid, nome, code);
		SendClientMessage(i ,vinho, string);
		}
		}
}*/

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
    if(PlayerInfo[playerid][pAdmin] > 1)
    {
        SetPlayerPosFindZ(playerid, fX, fY, fZ);
    }
    return 1;
}

forward Velocimetro(playerid);
public Velocimetro(playerid)
{
	new string[64];
	
	PlayerTextDrawDestroy(playerid, Vel[playerid]);
	PlayerTextDrawDestroy(playerid, Gas[playerid]);
	format(string, sizeof(string), "%d KM/H", GetVehicleSpeed(GetPlayerVehicleID(playerid)));
	Vel[playerid] = CreatePlayerTextDraw(playerid, 290.0, 420.0, string);
	PlayerTextDrawShow(playerid, Vel[playerid]);
	
	
	format(string, sizeof(string), "Gasolina: %d", gasolina[GetPlayerVehicleID(playerid)]);
	Gas[playerid] = CreatePlayerTextDraw(playerid, 290.0, 430.0, string);
	PlayerTextDrawShow(playerid, Gas[playerid]);
	
	
	if(IsPlayerInAnyVehicle(playerid))
	{
	SetTimerEx("Velocimetro", 500, false, "i", playerid);
	}
	else
	{
	PlayerTextDrawDestroy(playerid, Vel[playerid]);
	PlayerTextDrawDestroy(playerid, Gas[playerid]);
	}
	
	return 1;
	
}


public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(oldstate == PLAYER_STATE_ONFOOT && newstate == PLAYER_STATE_DRIVER) // Player entered a vehicle as a driver
    {
	    new string[64];
	    new Query[70];
		new vehicleid;
	    vehicleid = GetPlayerVehicleID(playerid);

		mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
	 	mysql_query(IDConexao, Query);

	 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);

		if(VehicleInfo[vehicleid][pDono] == PlayerInfo[playerid][pID])
		{
			format(string, sizeof(string), "Bem-vindo ao seu carro %s. Placa: %d", ReturnName(playerid, 0),vehicleid);
			SendClientMessage(playerid, amarelo, string);
		}

		Velocimetro(playerid);

    }
    if(oldstate == PLAYER_STATE_DRIVER && newstate == PLAYER_STATE_ONFOOT) // Player entered a vehicle as a driver
    {
    PlayerTextDrawDestroy(playerid, Vel[playerid]);
    PlayerTextDrawDestroy(playerid, Gas[playerid]);
    }
    
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    new engine, lights, alarm, doors, bonnet, boot, objective;
	new vehicleid;
	new Query[80];
	
	if (PRESSED(KEY_ACTION))
	{
	vehicleid = GetPlayerVehicleID(playerid);
 	if(vehicleid == 0) return 1;

	mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);
 	
 	if(VehicleInfo[vehicleid][pDono] != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você não possui a chave desse veículo.");

	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	if(engine == 0)
	{
	SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {00CC00}ligado.");
	}
	if(engine == 1)
	{
	SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {FF0000}desligado.");
	}
	}
	
	
	if (PRESSED(KEY_SECONDARY_ATTACK))
	{
	
	if(GetPlayerVirtualWorld(playerid) == 0)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 2101.9924, 2257.4414, 11.0234))//bincoLV
	      {
	      SetPlayerPos(playerid, 207.6284, -111.0890, 1005.1328);
	      SetPlayerInterior(playerid, 15);
	      SetPlayerVirtualWorld(playerid, 1);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
	      }

	 	if(IsPlayerInRangeOfPoint(playerid, 2.0, 1656.8474, 1733.3461, 10.8281))//bincoLV
	      {
		 SetPlayerPos(playerid, 207.6284, -111.0890, 1005.1328);
	      SetPlayerInterior(playerid, 15);
	      SetPlayerVirtualWorld(playerid, 2);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
	      }

	    if(IsPlayerInRangeOfPoint(playerid, 2.0, 2244.3831, -1665.4498, 15.4766))//bincoLS
	      {
            SetPlayerPos(playerid, 207.6284, -111.0890, 1005.1328);
	      SetPlayerInterior(playerid, 15);
	      SetPlayerVirtualWorld(playerid, 3);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
	      }
    	if(IsPlayerInRangeOfPoint(playerid, 2.0, 2364.5852,2377.6272,10.8203))//Imobiliaria
	      {
     		SetPlayerPos(playerid, 1494.4463,1303.7946,1093.2891);
	      SetPlayerInterior(playerid, 3);
	      SetPlayerVirtualWorld(playerid, 1);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
	      }
	      
	}
	
	if(GetPlayerVirtualWorld(playerid) == 1)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 207.6284, -111.0890, 1005.1328))
  		{
			SetPlayerPos(playerid, 2101.9924, 2257.4414, 11.0234);
	      SetPlayerInterior(playerid, 0);
	      SetPlayerVirtualWorld(playerid, 0);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
  		}
  		
  		if(IsPlayerInRangeOfPoint(playerid, 2.0, 1494.4463,1303.7946,1093.2891))
  		{
			SetPlayerPos(playerid, 2364.5852,2377.6272,10.8203);
	      SetPlayerInterior(playerid, 0);
	      SetPlayerVirtualWorld(playerid, 0);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
  		}
	}
	if(GetPlayerVirtualWorld(playerid) == 2)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 207.6284, -111.0890, 1005.1328))
  		{
			SetPlayerPos(playerid, 1656.8474, 1733.3461, 10.8281);
	      SetPlayerInterior(playerid, 0);
	      SetPlayerVirtualWorld(playerid, 0);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
  		}
	}
	if(GetPlayerVirtualWorld(playerid) == 3)
	{
		if(IsPlayerInRangeOfPoint(playerid, 2.0, 207.6284, -111.0890, 1005.1328))
  		{
			SetPlayerPos(playerid, 2244.3831, -1665.4498, 15.4766);
	      SetPlayerInterior(playerid, 0);
	      SetPlayerVirtualWorld(playerid, 0);
		  TogglePlayerControllable(playerid, 0);
		  SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
		  SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
  		}
	}
	
	
	
    for(new i = 1; i < 9; i++)
	{
		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `HQ` WHERE ID='%d'", i);
	 	mysql_query(IDConexao, Query);
	 	
	 	cache_get_value_int(0, "IntID", HQInfo[i][pIntID]);
	    cache_get_value_int(0, "VirtualW", HQInfo[i][VirtualW]);
		cache_get_value_float(0, "Picx", HQInfo[i][pPicx]);
		cache_get_value_float(0, "Picy", HQInfo[i][pPicy]);
		cache_get_value_float(0, "Picz", HQInfo[i][pPicz]);

		cache_get_value_float(0, "Intx", HQInfo[i][pIntx]);
		cache_get_value_float(0, "Inty", HQInfo[i][pInty]);
		cache_get_value_float(0, "Intz", HQInfo[i][pIntz]);
		
		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, HQInfo[i][pPicx], HQInfo[i][pPicy], HQInfo[i][pPicz]))
		    {
		   	SetPlayerPos(playerid, HQInfo[i][pIntx], HQInfo[i][pInty], HQInfo[i][pIntz]);
		   	SetPlayerInterior(playerid, HQInfo[i][pIntID]);
		 	SetPlayerVirtualWorld(playerid, HQInfo[i][VirtualW]);
			TogglePlayerControllable(playerid, 0);
			SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
			SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
		    }
	 	}
	 	
	 		if(GetPlayerVirtualWorld(playerid) == HQInfo[i][VirtualW])
		{
		 	if(IsPlayerInRangeOfPoint(playerid, 2.0, HQInfo[i][pIntx], HQInfo[i][pInty], HQInfo[i][pIntz]))
		 	{
		    SetPlayerPos(playerid,HQInfo[i][pPicx], HQInfo[i][pPicy], HQInfo[i][pPicz]);
		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);
		 	TogglePlayerControllable(playerid, 0);
			SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
			SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
		 	}
	 	}
	 	
	}//Final do count das HQs

	for(new i = 1; i < counthouse; i++)
	{
	 	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `Casas` WHERE ID='%d'", i);
	 	mysql_query(IDConexao, Query);

	    cache_get_value_int(0, "IntID", HouseInfo[i][pIntID]);
	    cache_get_value_int(0, "VirtualW", HouseInfo[i][pVirtualW]);
		cache_get_value_float(0, "Picx", HouseInfo[i][pPicx]);
		cache_get_value_float(0, "Picy", HouseInfo[i][pPicy]);
		cache_get_value_float(0, "Picz", HouseInfo[i][pPicz]);

		cache_get_value_float(0, "Intx", HouseInfo[i][pIntx]);
		cache_get_value_float(0, "Inty", HouseInfo[i][pInty]);
		cache_get_value_float(0, "Intz", HouseInfo[i][pIntz]);

		if(GetPlayerVirtualWorld(playerid) == 0)
		{
			if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][pPicx], HouseInfo[i][pPicy], HouseInfo[i][pPicz]))
		    {
		   	SetPlayerPos(playerid, HouseInfo[i][pIntx], HouseInfo[i][pInty], HouseInfo[i][pIntz]);
		   	SetPlayerInterior(playerid, HouseInfo[i][pIntID]);
		 	SetPlayerVirtualWorld(playerid, HouseInfo[i][pVirtualW]);
			TogglePlayerControllable(playerid, 0);
			SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
			SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
		    }
	 	}

	 	if(GetPlayerVirtualWorld(playerid) == HouseInfo[i][pVirtualW])
		{
		 	if(IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[i][pIntx], HouseInfo[i][pInty], HouseInfo[i][pIntz]))
		 	{
		    SetPlayerPos(playerid,HouseInfo[i][pPicx], HouseInfo[i][pPicy], HouseInfo[i][pPicz]);
		    SetPlayerInterior(playerid, 0);
		    SetPlayerVirtualWorld(playerid, 0);
		 	TogglePlayerControllable(playerid, 0);
			SendClientMessage(playerid, amarelo, "Aguarde 1 segundo.");
			SetTimerEx("DescongelarSpawn", 1000, false, "i", playerid);
		 	}
	 	}
 	}//Final do for counthouse
 	
 	
	
	}
	return 1;
}

//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================
//====================================COMANDOS ABAIXO=================================

//==========================SISTEMA DE BANCO======================================

CMD:saldo(playerid, params[])
{
 	CheckCaixa(playerid);
 	if(nocaixa[playerid] == 1)
 	{
	new stringsaldo[50];
	format(stringsaldo, sizeof(stringsaldo), "Saldo: $%d", PlayerInfo[playerid][pSaldo]);
    SendClientMessage(playerid, amarelo, stringsaldo);
    nocaixa[playerid] = 0;
    }
    else
    {
    SendClientMessage(playerid, vermelho, "Você não esta em um caixa eletronico ou no banco.");
    }
    return 1;
}

CMD:sacar(playerid, params[])
{
		new stringsaldo[50];
		new Cash;
        if(sscanf(params, "d", Cash)) return SendClientMessage(playerid, vermelho, "USE: /sacar [Quantia]");
		{
		CheckCaixa(playerid);
		if(nocaixa[playerid] == 1)
 		{
 		if(PlayerInfo[playerid][pSaldo] < Cash) return SendClientMessage(playerid, vermelho, "Voce nao tem essa quantia no banco!");
		PlayerInfo[playerid][pSaldo] = PlayerInfo[playerid][pSaldo] - Cash;
		GivePlayerMoney(playerid, Cash);
		format(stringsaldo, sizeof(stringsaldo), "Saldo: $%d", PlayerInfo[playerid][pSaldo]);
    	SendClientMessage(playerid, amarelo, stringsaldo);
    	nocaixa[playerid] = 0;
		}
		else
	    {
	    SendClientMessage(playerid, vermelho, "Você não esta em um caixa eletronico ou no banco.");
	    }
		}
		return 1;
}

CMD:depositar(playerid, params[])
{
        new stringsaldo[50];
		new Cash;
        if(sscanf(params, "d", Cash)) return SendClientMessage(playerid, vermelho, "USE: /depositar [Quantia]");
		{
		if(GetPlayerMoney(playerid) < Cash) return SendClientMessage(playerid, vermelho, "Voce nao tem essa quantia!");
        CheckCaixa(playerid);
		if(nocaixa[playerid] == 1)
		{
		PlayerInfo[playerid][pSaldo] = PlayerInfo[playerid][pSaldo] + Cash;
		GivePlayerMoney(playerid, -Cash);
		format(stringsaldo, sizeof(stringsaldo), "Saldo: $%d", PlayerInfo[playerid][pSaldo]);
    	SendClientMessage(playerid, amarelo, stringsaldo);
    	nocaixa[playerid] = 0;
		}
		else
	    {
	    SendClientMessage(playerid, vermelho, "Você não esta em um caixa eletronico ou no banco.");
	    }
		}
		return 1;
}

CMD:transferir(playerid, params[])
{
    new stringdepositante[50];
    new stringrecebidor[50];
	new transfid;
	new quantia;
 	if(sscanf(params, "ud", transfid, quantia)) return SendClientMessage(playerid, vermelho, "USE: /transferir [ID] [Quantia]");
	{
	if(!IsPlayerConnected(transfid)) return SendClientMessage(playerid, vermelho, "Esse jogador não esta logado!");
	if(transfid == playerid) return SendClientMessage(playerid, vermelho, "Você não pode fazer uma transferencia para você mesmo.");
    CheckCaixa(playerid);
    
	if(nocaixa[playerid] == 1)
	{
	if(PlayerInfo[playerid][pSaldo] < quantia) return SendClientMessage(playerid, vermelho, "Voce nao tem essa quantia no banco!");
	PlayerInfo[playerid][pSaldo] = PlayerInfo[playerid][pSaldo] - quantia;
	PlayerInfo[transfid][pSaldo] = PlayerInfo[transfid][pSaldo] + quantia;
	
	format(stringdepositante, sizeof(stringdepositante), "Você transferiu $%d para %s", quantia, ReturnName(transfid, 0));
	SendClientMessage(playerid, amarelo, stringdepositante);
	format(stringrecebidor, sizeof(stringrecebidor), "%s te transferiu $%d", ReturnName(playerid, 0),quantia);
	SendClientMessage(transfid, amarelo, stringrecebidor);
	nocaixa[playerid] = 0;
	}
	else
	    {
	    SendClientMessage(playerid, vermelho, "Você não esta em um caixa eletronico ou no banco.");
	    }
	}
	return 1;
}


//=================================================================================

CMD:comprar(playerid, params[])
{
	Comprar(playerid);
	return 1;
}

//================================SISTEMA DE CARRO========================================
//================================SISTEMA DE CARRO========================================
//================================SISTEMA DE CARRO========================================
CMD:v(playerid,params[])
{
	new engine, lights, alarm, doors, bonnet, boot, objective;
	new vehicleid;
	new Query[350];
	
	if (!isnull(params) && !strcmp(params, "ligar", true))
 	{
 	vehicleid = GetPlayerVehicleID(playerid);
 	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta em um veículo.");
 	
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);
 	if(VehicleInfo[vehicleid][pDono] != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você não possui a chave desse veículo.");
 	if(gasolina[vehicleid] == 0) return SendClientMessage(playerid, COLOR_WHITE, "Esse veículo esta sem gasolina.");
 	
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, 1, lights, alarm, doors, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {00CC00}ligado.");
	}
	
	if (!isnull(params) && !strcmp(params, "des", true))
	{
	vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta em um veículo.");
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {FF0000}desligado.");
	}
	
	if (!isnull(params) && !strcmp(params, "desligar", true))
	{
	vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta em um veículo.");
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, 0, lights, alarm, doors, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {FF0000}desligado.");
	}
	
	if (!isnull(params) && !strcmp(params, "trancar", true))
	{
	vehicleid =	GetClosestVehicle(playerid);
	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta perto de nenhum veículo.");
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);
 	if(VehicleInfo[vehicleid][pDono] != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você não possui a chave desse veículo.");
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, 1, alarm, 1, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {FF0000}trancado.");
	SetTimerEx("ApagarFarol", 250, false, "d", vehicleid);
	}
	
	if (!isnull(params) && !strcmp(params, "destrancar", true))
	{
	vehicleid =	GetClosestVehicle(playerid);
	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta perto de nenhum veículo.");
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);
 	if(VehicleInfo[vehicleid][pDono] != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você não possui a chave desse veículo.");
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, 1, alarm, 0, bonnet, boot, objective);
	SendClientMessage(playerid, COLOR_WHITE, "Veículo {00CC00}destrancado.");
	SetTimerEx("ApagarFarol", 250, false, "d", vehicleid);
	}
	
	if (!isnull(params) && !strcmp(params, "alarmeon", true))
	{
	vehicleid =	GetClosestVehicle(playerid);
	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta perto de nenhum veículo.");
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);
 	if(VehicleInfo[vehicleid][pDono] != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você não possui a chave desse veículo.");
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, 1, alarm, 1, bonnet, boot, objective);
	SetTimerEx("ApagarFarol", 250, false, "d", vehicleid);
	}
	
	if (!isnull(params) && !strcmp(params, "alarmeoff", true))
	{
	vehicleid =	GetClosestVehicle(playerid);
	if(vehicleid == 0) return SendClientMessage(playerid, vermelho, "Você não esta perto de nenhum veículo.");
	mysql_format(IDConexao, Query, sizeof(Query), "SELECT `Dono` FROM `Carros` WHERE ID='%d'", vehicleid);
 	mysql_query(IDConexao, Query);
 	cache_get_value_int(0, "Dono", VehicleInfo[vehicleid][pDono]);
 	if(VehicleInfo[vehicleid][pDono] != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Você não possui a chave desse veículo.");
	GetVehicleParamsEx(vehicleid, engine, lights, alarm, doors, bonnet, boot, objective);
	SetVehicleParamsEx(vehicleid, engine, 1, alarm, 0, bonnet, boot, objective);
	SetTimerEx("ApagarFarol", 250, false, "d", vehicleid);
	}
	
	return 1;
}


//=====================================================================================
//=====================================================================================
//=====================================================================================

//===========================SISTEMA DE ORGANIZAÇÕES===============================
CMD:membros(playerid, params[])
{
	new pid;
	new nivel;
	new nome[20];
	new Query[80];
	new Query1[80];
	new string1[80];
	new string2[80];
	new string3[80];
	new string4[80];
	new string5[80];
	new string6[80];
	new string7[80];
	new string8[80];
	new string9[80];
	new string10[80];
	new stringfinal[800];
	
	switch(PlayerInfo[playerid][pOrg])
	{
	case 0:
	{
	return SendClientMessage(playerid, vermelho, "Voce não participa de nenhuma organização.");
	}
	case 1:
	{
		orgnumber[playerid] = 1;
		for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);
		 	
			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);

            
		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";
		 	
	 	}
 	}
 	case 2:
	{
    orgnumber[playerid] = 2;
 	for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}


	}
	case 3:
	{
	orgnumber[playerid] = 3;
	for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}

	}
	case 4:
	{
	orgnumber[playerid] = 4;
		for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}
	}
	case 5:
	{
	orgnumber[playerid] = 5;
    	for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}
	}
	case 6:
	{
	orgnumber[playerid] = 6;
    	for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}
	}
	case 7:
	{
	orgnumber[playerid] = 7;
    	for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}
	}
	case 8:
	{
	orgnumber[playerid] = 8;
    	for(new i = 1; i < 11; i++)
		{
			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", i);
		 	mysql_query(IDConexao, Query);
		 	cache_get_value_int(0, "pID", pid);
		 	cache_get_value_int(0, "Nivel", nivel);

			mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `Contas` WHERE ID='%d'", pid);
		 	mysql_query(IDConexao, Query1);
		 	cache_get_value(0, "Nome", nome, 20);


		    switch(i)
		    {
		    case 1:
		    {
			    if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string1, sizeof(string1),"Líder: \t[{FF0000}OFF{FFFFFF}] %s\tNivel %d", nome, nivel);
				}
				else
				{
				format(string1, sizeof(string1),"Líder: \t[{00CC00}ON{FFFFFF}] %s\tNivel %d", nome, nivel);
	  			}
			}
  			case 2:
		    {
		    	if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string2, sizeof(string2),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string2, sizeof(string2),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 3:
		    {
	    		if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string3, sizeof(string3),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string3, sizeof(string3),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 4:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string4, sizeof(string4),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string4, sizeof(string4),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 5:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string5, sizeof(string5),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string5, sizeof(string5),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 6:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string6, sizeof(string6),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string6, sizeof(string6),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 7:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string7, sizeof(string7),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string7, sizeof(string7),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 8:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string8, sizeof(string8),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string8, sizeof(string8),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 9:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string9, sizeof(string9),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string9, sizeof(string9),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			case 10:
		    {
				if (GetPlayerIdFromName(nome) == INVALID_PLAYER_ID)
				{
				format(string10, sizeof(string10),"Slot %d:\t[{FF0000}OFF{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
				}
				else
				{
				format(string10, sizeof(string10),"Slot %d:\t[{00CC00}ON{FFFFFF}] %s\tNivel %d" ,i, nome, nivel);
	  			}
			}
			}


  		 nome = "Nenhum.";

	 	}
	}
	
	}
	
		format(stringfinal, sizeof(stringfinal), "%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s\n\t%s", string1, string2, string3, string4, string5, string6, string7, string8, string9, string10);
		ShowPlayerDialog(playerid, DIALOG_MEMBROS, DIALOG_STYLE_TABLIST, "Membros",
		stringfinal,
		"Gerenciar", "Cancelar");

return 1;
}

CMD:convidar(playerid, params[])
{

	new pid;
	new nivel;
	new Query[80];
	new Query1[80];
	new inviteid;
	new string[150];
	new slot1;
	
	if (sscanf(params, "ud", inviteid, slot1)) return SendClientMessage(playerid, vermelho, "USE: /convidar [ID] [Slot]");
	{
		if (inviteid == INVALID_PLAYER_ID) return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");
	    if(slot1 < 1 && slot1 > 10) return SendClientMessage(playerid, vermelho, "O slot deve ser entre 1 e 10.");
	    if(PlayerInfo[inviteid][pOrg] != 0) return SendClientMessage(playerid, vermelho, "Esse jogador já participa de uma organização.");

	   	switch(PlayerInfo[playerid][pOrg])
		{
		case 0:
		{
		return SendClientMessage(playerid, vermelho, "Voce não participa de nenhuma organização.");
		}
		case 1:
		{

				mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmls` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");
				
				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `pmls` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);
			 	
			 	cache_get_value_int(0, "pID", pid);
			 	
			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");
			 	
			 	conviteorg[inviteid] = 1;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);
					
					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);
					
					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);


	 	}
	 	case 2:
		{

    			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pmlv` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `pmlv` WHERE ID='%d'", slot);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 2;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);


		}
		case 3:
		{
		
				mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `pc` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `pc` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 3;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);

		}
		case 4:
		{
        		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia1` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `mafia1` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 1;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);
		}
		case 5:
		{
        		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `mafia2` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `mafia2` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 1;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);
		}
		case 6:
		{
           		mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue1` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `gangue1` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 1;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);
		}
		case 7:
		{
            	mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `gangue2` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `gangue2` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 1;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);
		}
		case 8:
		{
	 			mysql_format(IDConexao, Query, sizeof(Query), "SELECT * FROM `samu` WHERE ID='%d'", 1);
			 	mysql_query(IDConexao, Query);
			 	cache_get_value_int(0, "pID", pid);
			 	cache_get_value_int(0, "Nivel", nivel);

				if(pid != PlayerInfo[playerid][pID]) return SendClientMessage(playerid, vermelho, "Voce não é o lider da organização.");

				mysql_format(IDConexao, Query1, sizeof(Query1), "SELECT * FROM `samu` WHERE ID='%d'", slot1);
			 	mysql_query(IDConexao, Query1);

			 	cache_get_value_int(0, "pID", pid);

			 	if(pid != 0) return SendClientMessage(playerid, vermelho, "Esse slot já esta ocupado por outro membro.");

			 	conviteorg[inviteid] = 1;
				slot[inviteid] = slot1;

					format(string, sizeof(string), "Você convidou %s para participar de sua organização.", ReturnName(inviteid, 1));
					SendClientMessage(playerid, azul_claro ,string);

					format(string, sizeof(string), "%s te convidou para participar da organização dele(a).", ReturnName(playerid, 1));
					SendClientMessage(inviteid, azul_claro ,string);

					format(string, sizeof(string), "Para aceitar o convite use '/aceitar convite'.");
					SendClientMessage(inviteid, azul_claro ,string);
		}

		}

    }

    
    return 1;
}


//=================================================================================


CMD:tp(playerid, params[])
{
    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], 1958, 1343, 15, 220, 0, 0, 0, 0, 0, 0 );
    SpawnPlayer(playerid); // forçamos o player a spawnar nas cordenas acima com as infos setadas nas variaveis
    return 1;
}

CMD:status(playerid, params[])
{
	new org[50];

	switch(PlayerInfo[playerid][pOrg])
{
	case 0:
	{
	org = "Nenhuma";
	}
	case 1:
	{
	org =  "PM-LS";
	}
	case 2:
	{
	org =  "PM-LV";
	}
	case 3:
	{
	org =  "Policia Civil";
	}
	case 4:
	{
	org =  "Mafia1";
	}
	case 5:
	{
	org =  "Mafia2";
	}
	case 6:
	{
	org =  "Gangue1";
	}
	case 7:
	{
	org =  "Gangue2";
	}
	case 8:
	{
	org =  "SAMU";
	}
}

	new string[954];
	format(string, sizeof(string), "Nome [{FFFFFF}%s{00CC00}] | Level [{FFFFFF}%d{00CC00}] | Respeito [{FFFFFF}%d/%d{00CC00}] | Organização [{FFFFFF}%s{00CC00}]",ReturnName(playerid, 0),PlayerInfo[playerid][pLevel],PlayerInfo[playerid][pResp],PlayerInfo[playerid][pRespobj],org);
	SendClientMessage(playerid, verde ,string);

    return 1;
}

CMD:meuscarros(playerid, params[])//==================================================================FAZER O COMANDO FUNCIONAR=======================================
{
	new string[954];
	format(string, sizeof(string), "");
	SendClientMessage(playerid, verde ,string);

    return 1;
}

CMD:relatorio(playerid, params[])
{
    new text[100];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, vermelho, "USE: /relatorio [Texto]");
	{
		new pname[MAX_PLAYER_NAME];
		GetPlayerName(playerid, pname, sizeof(pname));
		for(new i = 0; i < MAX_PLAYERS; i++)
			{
			if (PlayerInfo[i][pAdmin] > 1)
				{
				new string[100];
				format(string, sizeof(string), "Relatorio de %s: %s", pname, text);
		   	 	SendClientMessage(playerid, azul_claro, string);
		   	 	}
			}
		SendClientMessage(playerid, amarelo, "Seu relatorio foi enviado para os administradores.");
	}

	return 1;
}

CMD:g(playerid, params[])
{
    new text[200];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, vermelho, "USE: /g [Texto]");
	{
    new pname[MAX_PLAYER_NAME], str[128];//reduce it if you want
    GetPlayerName(playerid, pname, sizeof(pname));
  //  strreplace(pname, '_', ' ');
    format(str, sizeof(str), "%s grita: %s", pname, text);//Appearance of the text submitted by a nearby player.
    ProxDetector(25.0, playerid, str, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    }
    return 0;//So that the text is not submitted regularly.
}

CMD:b(playerid, params[])
{
    new text[200];
    if(sscanf(params, "s[128]", text)) return SendClientMessage(playerid, vermelho, "USE: /b [Texto]");
	{
    new pname[MAX_PLAYER_NAME], str[128];//reduce it if you want
    GetPlayerName(playerid, pname, sizeof(pname));
  //  strreplace(pname, '_', ' ');
    format(str, sizeof(str), "(( %s diz: %s ))", pname, text);//Appearance of the text submitted by a nearby player.
    ProxDetector(10.0, playerid, str, COLOR_FADE1, COLOR_FADE2, COLOR_FADE3, COLOR_FADE4, COLOR_FADE5);
    }
    return 0;//So that the text is not submitted regularly.
}

CMD:aceitar(playerid, params[])
{
	new Query1[80];

	if (!isnull(params) && !strcmp(params, "convite", true))
	{
	if(conviteorg[playerid] == 0) return SendClientMessage(playerid, vermelho, "Você não foi convidado para nenhuma organização.");

	switch(conviteorg[playerid])
	{
		case 1:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 1;
		}
		case 2:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 2;
		}
		case 3:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 3;
		}
		case 4:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 4;
		}
		case 5:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 5;
		}
		case 6:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 6;
		}
		case 7:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 7;
		}
		case 8:
		{
			mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=1 WHERE `ID`=%d",
			PlayerInfo[playerid][pID],
			slot[playerid]);
			mysql_query(IDConexao, Query1);
			PlayerInfo[playerid][pOrg] = 8;
		}
	}
	
	SendClientMessage(playerid, azul_claro, "Você aceitou o convite da organização.");
	conviteorg[playerid] = 0;
	}
	return 1;
}

//===================================Sistema de Admin=====================================
//===================================Sistema de Admin=====================================
//===================================Sistema de Admin=====================================

CMD:tempo(playerid, params[])
{
		new weather;
		new string[50];
		
		if (PlayerInfo[playerid][pAdmin] < 5)
	    return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	    
     	if(sscanf(params, "d", weather)) return SendClientMessage(playerid, vermelho, "USE: /tempo [WeatherID]");
	{
		SetWeather(weather);
		for(new i = 0; i < MAX_PLAYERS; i++)
	{
		format(string, sizeof(string), "Tempo atual: %d", weather);
		SendClientMessage(i, azul_claro, string);
		}
	}

	return 1;
}

CMD:forcepd(playerid, params[])//Comando de admin
{
	if (PlayerInfo[playerid][pAdmin] < 5)
 	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	Forcepd = 1;
	PayDay();
	return 1;
}

//============================================ADMIN 1=====================================
CMD:spec(playerid, params[])//Comando de admin
{
	new Float:x;
	new Float:y;
	new Float:z;
	new Float:rot;
	new string[50];
	new userid;

	if (PlayerInfo[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");

	if (!isnull(params) && !strcmp(params, "off", true))
	{
	    if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
			return SendClientMessage(playerid, vermelho, "Voce não esta mais espectanto nenhum jogandor.");

	    PlayerSpectatePlayer(playerid, INVALID_PLAYER_ID);
	    PlayerSpectateVehicle(playerid, INVALID_VEHICLE_ID);

	    SetSpawnInfo(playerid, 0, PlayerInfo[playerid][pSkin], PlayerInfo[playerid][pX], PlayerInfo[playerid][pY], PlayerInfo[playerid][pZ], PlayerInfo[playerid][pRot], 0, 0, 0, 0, 0, 0);
	    TogglePlayerSpectating(playerid, false);

	    return SendClientMessage(playerid, amarelo, "Você não esta mais em modo espectator.");
	}
	if (sscanf(params, "u", userid))
		return SendClientMessage(playerid, vermelho, "/spec [ID/NOME] - Use \"/spec off\" para sair do modo espectador.");

	if (userid == INVALID_PLAYER_ID)
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");
	    
	if (userid == playerid)
	    return SendClientMessage(playerid, vermelho, "Você nao pode usar esse comando em você mesmo.");

	if (GetPlayerState(playerid) != PLAYER_STATE_SPECTATING)
	{
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, rot);

	//	interior = GetPlayerInterior(playerid);
	//	world = GetPlayerVirtualWorld(playerid);
	}
	SetPlayerInterior(playerid, GetPlayerInterior(userid));
	SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(userid));

	TogglePlayerSpectating(playerid, 1);

	if (IsPlayerInAnyVehicle(userid))
	    PlayerSpectateVehicle(playerid, GetPlayerVehicleID(userid));

	else
		PlayerSpectatePlayer(playerid, userid);
		
 	format(string, sizeof(string), "Você esta espectando %s", ReturnName(userid, 1));
	SendClientMessage(playerid, azul_claro, string);
	
//	PlayerData[playerid][pSpectator] = userid;

	return 1;
}

CMD:kick(playerid, params[])
{
	static
	    userid,
	    reason[128];
	    new string[128];

    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");

	if (sscanf(params, "us[128]", userid, reason))
	    return SendClientMessage(playerid, vermelho, "USE: /kick [ID/NOME] [Motivo].");

	if (userid == INVALID_PLAYER_ID || (!IsPlayerConnected(userid)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");

    if (PlayerInfo[userid][pAdmin] > PlayerInfo[playerid][pAdmin])
	    return SendClientMessage(playerid, vermelho, "Este jogador é superior a você.");
	    
	format(string, sizeof(string), "[ADMIN]: %s kickou %s. MOTIVO: %s.", ReturnName(playerid, 0), ReturnName(userid, 0), reason);
	SendClientMessageToAll(roxo, string);

	Kick(userid);
	return 1;
}

CMD:congelar(playerid, params[])
{
	static
	userid;
	new string[128];
	new string1[128];
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	    
   	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, vermelho, "USE: /congelar [ID/NOME].");
	    
   	if (userid == INVALID_PLAYER_ID || (!IsPlayerConnected(userid)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");
	    
	    TogglePlayerControllable(userid, 0);
	    
    	format(string, sizeof(string), "Você foi congelado por um administrador.");
		SendClientMessage(userid, azul_claro,string);
 		format(string1, sizeof(string1), "Atenção: Se deslogar poderá sofrer consequencias!");
		SendClientMessage(userid, vermelho,string1);
		return 1;
}

CMD:descongelar(playerid, params[])
{
	static
	userid;
	new string[128];
    if (PlayerInfo[playerid][pAdmin] < 1)
	    return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");

   	if (sscanf(params, "u", userid))
	    return SendClientMessage(playerid, vermelho, "USE: /descongelar [ID/NOME].");

   	if (userid == INVALID_PLAYER_ID || (!IsPlayerConnected(userid)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");

	    TogglePlayerControllable(userid, 1);

    	format(string, sizeof(string), "Você foi descongelado por um administrador.");
		SendClientMessage(userid, azul_claro,string);
		return 1;
}

CMD:skin(playerid, params[])
{
	static
	    userid,
		skinid;
    new string[128];
    new string1[128];
    
    if (PlayerInfo[playerid][pAdmin] < 1)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");

	if (sscanf(params, "ud", userid, skinid))
        return SendClientMessage(playerid, vermelho, "USE: /skin [ID/NOME] [SKIN ID].");

   	if (userid == INVALID_PLAYER_ID || (!IsPlayerConnected(userid)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");

	if (skinid < 0 || skinid > 299)
	    return SendClientMessage(playerid, vermelho, "Skin ID invalida. Skins validas de 0 até 299.");

	SetPlayerSkin(userid, skinid);
	PlayerInfo[userid][pSkin] = skinid;

	format(string, sizeof(string), "Sua skin foi trocada por um administrador (Skin: %d).", skinid);
	SendClientMessage(userid, azul_claro,string);
	
	format(string1, sizeof(string1), "Você trocou a skin de %s (Skin: %d).", ReturnName(playerid, 0),skinid);
	SendClientMessage(playerid, azul_claro, string1);

	return 1;
}

CMD:ir(playerid, params[])
{
	static
	id;
	new string[128];
    if (PlayerInfo[playerid][pAdmin] < 1)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "u", id))
        return SendClientMessage(playerid, vermelho, "USE: /ir [ID/NOME].");
	if (id == INVALID_PLAYER_ID || (!IsPlayerConnected(id)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");
	    
    SendPlayerToPlayer(playerid, id);
    
   	format(string, sizeof(string), "Você foi até o jogador %s.", ReturnName(id, 0));
	SendClientMessage(playerid, azul_claro, string);
	return 1;
}

CMD:trazercarro(playerid, params[])
{
	static
	id;
	new string[128];
    if (PlayerInfo[playerid][pAdmin] < 1)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "d", id))
        return SendClientMessage(playerid, vermelho, "USE: /trazercarro [Placa].");

    SendCarToPlayer(id, playerid);

   	format(string, sizeof(string), "Você puxou o carro %d.", id);
	SendClientMessage(playerid, azul_claro, string);
	return 1;
}

//============================================ADMIN 2=====================================

CMD:respawn(playerid, params[])
{
	static
 	userid;
	new string[128];
	new string1[128];
 	
  	if (PlayerInfo[playerid][pAdmin] < 2)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "u", userid))
        return SendClientMessage(playerid, vermelho, "USE: /respawn [ID/NOME]");
	if (userid == INVALID_PLAYER_ID || (!IsPlayerConnected(userid)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");
	    
    	format(string, sizeof(string), "Você foi respawnado por um administrador.");
		SendClientMessage(userid, azul_claro, string);

 		format(string1, sizeof(string1), "Voce respawnou o jogador %s.", ReturnName(userid, 0));
		SendClientMessage(playerid, azul_claro, string1);
	    
	    RespawnPlayer(userid);
	    return 1;
}

CMD:darlider(playerid, params[])//Comando de admin
{
	new inviteid;
	new orgnum;
	new Query1[350];
 	if(sscanf(params, "dd", inviteid, orgnum)) return SendClientMessage(playerid, vermelho, "USE: /setorg [ID] [ORG]");
	{
	if (PlayerInfo[playerid][pAdmin] < 4)
	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if(!IsPlayerConnected(inviteid)) return  SendClientMessage(playerid, vermelho, "Esse jogador não esta logado!");
	if(PlayerInfo[inviteid][pOrg] > 0) return  SendClientMessage(playerid, vermelho, "Esse jogador já participa de uma organização.");
	if(orgnum > 8) return  SendClientMessage(playerid, vermelho, "Não há mais que 8 organizações.");
	
	PlayerInfo[inviteid][pOrg] = orgnum;

	switch(orgnum)
	{
	case 1:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmls` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 2:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pmlv` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 3:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `pc` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 4:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 5:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `mafia2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 6:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue1` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 7:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `gangue2` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	case 8:
	{
	mysql_format(IDConexao, Query1, sizeof(Query1), "UPDATE `samu` SET `pID`=%d,`Nivel`=%d WHERE `ID`=%d",
	PlayerInfo[inviteid][pID],
	5,
	1);
	mysql_query(IDConexao, Query1);
	}
	
	}


	SendClientMessage(inviteid, azul_claro, "Um administrador te deu liderança.");

	}
	return 1;
}

CMD:daradmin(playerid, params[])
{
	static
	userid;
	new nivel;
	new string[128];
	new string1[128];
	
      		if (PlayerInfo[playerid][pAdmin] < 5)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
    		if (sscanf(params, "ud", userid, nivel))
        return SendClientMessage(playerid, vermelho, "USE: /daradmin [ID/NOME] [Nivel].");
        	if (userid == INVALID_PLAYER_ID || (!IsPlayerConnected(userid)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");
    		if (nivel > 5)
	    return SendClientMessage(playerid, vermelho, "O nivel maximo de admin é 5.");
	    
	    PlayerInfo[userid][pAdmin] = nivel;
	    
    	format(string, sizeof(string), "Um administrador te definiu como Admin %d.", nivel);
		SendClientMessage(userid, azul_claro, string);
		
 		format(string1, sizeof(string1), "Voce tornou %s administrador nivel %d.", ReturnName(userid, 0), nivel);
		SendClientMessage(playerid, azul_claro, string1);
		return 1;
}

CMD:trazer(playerid, params[])
{
	static
	id;
	new string[128];
	new string1[128];
    if (PlayerInfo[playerid][pAdmin] < 2)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "u", id))
        return SendClientMessage(playerid, vermelho, "USE: /trazer [ID/NOME].");
	if (id == INVALID_PLAYER_ID || (!IsPlayerConnected(id)))
	    return SendClientMessage(playerid, vermelho, "Esse jogador não esta online.");

    SendPlayerToPlayer(id, playerid);

   	format(string, sizeof(string), "Você trouxe o jogador %s.", ReturnName(playerid, 0));
	SendClientMessage(playerid, azul_claro, string);

	format(string1, sizeof(string1), "Você foi puxado por um administrador.");
	SendClientMessage(id, azul_claro, string1);

	return 1;
}

CMD:gmx(playerid, params[])
{
   		new string[128];
		if (PlayerInfo[playerid][pAdmin] < 5)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
   		format(string, sizeof(string), "[SERVER]: GMX no servidor agora msm, leu, ja passou.");
		SendClientMessageToAll(roxo, string);
   		for(new i = 0; i < MAX_PLAYERS; i++)
		{
		SalvarDados(i);
		}
		mysql_close(IDConexao); // Aqui fechamos a conexão com o host
		SetTimer("GMX", 1000, false);
		return 1;
		
}

CMD:tocar(playerid, params[])
{
	static
	id;
	new string[128];
	new Float:x;
	new Float:y;
	new Float:z;
	
    if (PlayerInfo[playerid][pAdmin] < 2)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "d", id))
        return SendClientMessage(playerid, vermelho, "USE: /tocar [ID].");
		GetPlayerPos(playerid,x,y,z);

		for(new i = 0; i < MAX_PLAYERS; i++)
		{
    	PlayerPlaySound(i, id, x, y, z);
    	}
    	
   		format(string, sizeof(string), "Tocando musica ID: %d", id);
		SendClientMessageToAll(azul_claro, string);
	return 1;
}

CMD:car(playerid, params[])
{
	new string[128];
	new Float:x;
	new Float:y;
	new Float:z;

    if (PlayerInfo[playerid][pAdmin] < 2)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "d", buycar))
        return SendClientMessage(playerid, vermelho, "USE: /car [ID].");
	if(buycar < 400) return SendClientMessage(playerid, vermelho, "O ID deve ser maior que 400.");
		GetPlayerPos(playerid,x,y,z);
		CreateVehicle(buycar, x + 2, y, z, 82.2873, -1, -1, 0);
		format(string, sizeof(string), "Veículo spawnado ID: %d", buycar);
		SendClientMessageToAll(azul_claro, string);
		CriarCarro(playerid);
		
		return 1;
}

CMD:estacionar(playerid, params[])
{
	SalvarCarro(playerid);
	return 1;
}

CMD:armas(playerid, params[])
{

ShowPlayerDialog(playerid, DIALOG_AMMOCLAN, DIALOG_STYLE_TABLIST, "Ammu-Clandestina",
"Deagle\t$5\t80\n\
M4A4\t$10\t250\n\
Spas-12\t$15\t100",
"Comprar", "Cancelar");
}

CMD:pickup(playerid, params[])
{
	new Float:x, Float:y, Float:z;
	GetPlayerPos(playerid, x, y, z);
	CreatePickup(1239, 3, x, y+2, z, 0);

	return 1;
}

CMD:criarcasa(playerid, params[])
{
    if (PlayerInfo[playerid][pAdmin] < 5)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
        
ShowPlayerDialog(playerid, DIALOG_CRIARCASA, DIALOG_STYLE_TABLIST, "Criar casa",
"Mansão\tGrande\t$2000000\n\
Casa\tMédio\t$600000\n\
Casa\tPequeno\t$300000",
"Criar", "Cancelar");
return 1;
}

CMD:setarhq(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
    	
   		if (sscanf(params, "dd", hqid[playerid], HouseID[playerid]))
        return SendClientMessage(playerid, vermelho, "USE: /setarhq [Org] [IntID].");

		if(hqid[playerid] < 1 || hqid[playerid] > 8)
		return SendClientMessage(playerid, vermelho, "As organizações vão apenas de 1 a 8.");
		
		SetarHQ(playerid);
        
    	return 1;
}

CMD:setarcofre(playerid, params[])
{
	if (PlayerInfo[playerid][pAdmin] < 5)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");

   		if (sscanf(params, "d", hqid[playerid]))
        return SendClientMessage(playerid, vermelho, "USE: /setarcofre [Org].");
        if(hqid[playerid] < 1 || hqid[playerid] > 8)
		return SendClientMessage(playerid, vermelho, "As organizações vão apenas de 1 a 8.");
		
		SetarCofre(playerid);
        return 1;
}

CMD:time(playerid, params[])//Comando de admin
{
	new hora, minu, sec;
	new stringsaldo[50];
	gettime(hora, minu, sec);
	format(stringsaldo, sizeof(stringsaldo), "Hora: %d:%d:%d",hora, minu, sec);
	SendClientMessage(playerid, amarelo, stringsaldo);
	return 1;
}

CMD:tapao(playerid, params[])
{
	static
	id;
	new Float:x;
	new Float:y;
	new Float:z;

    if (PlayerInfo[playerid][pAdmin] < 2)
    	return SendClientMessage(playerid, vermelho, "Você não tem permissão para usar esse comando.");
	if (sscanf(params, "u", id))
        return SendClientMessage(playerid, vermelho, "USE: /tapao [ID].");
		GetPlayerPos(id,x,y,z);
		SetPlayerPos(id,x,y,z+10);
		return 1;

}





