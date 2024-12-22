Program Make_Menu;           { mise … jour 01 - 02 - 1991 }
{
Ce programme permet de cr‚er des fichiers .BAT servant de menus. Il faut
imp‚rativement copier le fichier CHOIX.COM dans le mˆme sous-r‚pertoire
que le menu .BAT.

En effet, ce fichier fait en assembleur permet d'attendre l'appuit sur une
touche, puis la transforme en majuscule (si c'est possible), puis il rend
la main en renvoyant le code de la touche dans le registre AL. C'est ainsi
que l'on peut savoir quelle touche a ‚t‚ appuy‚e lors du test de ERRORLEVEL.

Auteur : Pr‚martin Patrick.
Date de la version 1.0: 01-02-1991.
}

Uses
    olf_software,
    u_Fenetre,
     u_Aff_Speciaux,
     u_Aff_Chaine,
     u_ger_Chaine,
     u_Sgf,
     Crt;

Const
     Num_Ver : String [3]  = '1.0';
      Dat_Ver : String [10] = '01-02-1991';
      Param   : Boolean     = False;
      Cr                    = #13;
      Bell                  = #07;

Type T_Ligne  = String;
     T_Ecran  = Array [1..24] Of T_Ligne;
     T_Fich   = Array [1..24] Of String;

Var Nom_Fichier : String;

Procedure Initialisation;
Begin { initialisation }
  If ((Not Param) And (Paramcount > 0))
  Then
    Nom_Fichier := Paramstr (1)
  Else
    Nom_Fichier := 'NONAME'
  {endif};
  Met_Extension (Nom_Fichier, 'bat', Nom_Fichier);
  Nom_Fichier := Set_Maj_Chaine (Nom_Fichier);
  Param := True
End; { initialisation }

Procedure Attente_Appuit_Touche;
Var Carac : Char;
Begin { attente_appuit_touche }
  Textcolor (Lightgray);
  Textbackground (Black);
  Affic_Center ('Appuyez sur une touche...');
  While (Keypressed) Do
    Carac := Readkey
  {endwhile};
  Carac := Readkey;
  While (Keypressed) Do
    Carac := Readkey
  {endwhile};
  Gotoxy (1, Wherey);
  Clreol
End; { attente_appuit_touche }

Procedure Presentation;
Begin { presentation }
  Clear_Screen;
  Type_Cadre := 4;
  Window_Fond_Cadre_Bis (2, 2, 79, 18, Lightgray, Lightred, Blue);
  Window_Titre ('Make Menu', White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Affic_Center_Ln ('de Pr‚martin Patrick');
  Affic_Center_Ln (Concat ('Version ', Num_Ver, ' dat‚e du ', Dat_Ver, '.'));
  Write_String (3, 4,  '   Ce programme g‚nŠre des fichiers de commandes (.BAT) qui permettent de');
  Write_String (3, 5,  'jouer le role de menus. Les fichiers ainsi cr‚‚s necessitent la pr‚sence ');
  Write_String (3, 6,  'dans leur r‚pertoire du fichier CHOIX.COM inclus dans le r‚pertoire de ce');
  Write_String (3, 7,  'programme.');
  Write_String (3, 9,  '   Le fichier CHOIX.COM attend que l''utilisateur appuie sur une touche,');
  Write_String (3, 10, 'puis il renvoie le code de cette touche mise en majuscule par le registre');
  Write_String (3, 11, 'AL, on peut ainsi tester le code retourn‚ grƒce … ERRORLEVEL sous MS-DOS');
  Write_String (3, 13, '   Vous pouvez lancer ce programme en passant un paramŠtre qui sera le nom');
  Write_String (3, 14, 'du fichier de commandes que vous voulez cr‚er.');
  Write_String (3, 15, '     ex: MAKEMENU AUTOEXEC');
  Display_Bloc_Vert (2, 4, 78, 15);
  Writeln;
  Attente_Appuit_Touche;
  Clear_Screen;
  Clear_Window
End; { presentation }

Procedure Ask_Nom_Fichier (Var Nom_Fichier : String);
Var Nom_Fic : String;
Begin { ask_nom_fichier }
  Type_Cadre := 5;
  Window_Fond_Cadre_Bis (2, 2, 79, 3, Lightgray, Lightred, Blue);
  Window_Titre ('Nom du fichier', White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Repeat
    Writeln ('Ancien nom: ', Nom_Fichier);
    Write ('Nouveau nom ? ');
    Readln (Nom_Fic);
    If (Nom_Fic <> '')
    Then
      Nom_Fichier := Nom_Fic
    {endif};
    Nom_Fichier := Set_Maj_Chaine (Nom_Fichier);
    Met_Extension (Nom_Fichier, 'BAT', Nom_Fichier)
  Until (Nom_Fic = '');
  Clear_Window
End; { ask_nom_fichier }

Function Question_Oui_Non (Chaine : String; Defaut : Boolean) : Boolean;
Var Carac : Char;
Begin { question_oui_non }
  Type_Cadre := 6;
  Window_Fond_Cadre_Bis (2, 2, 79, 4, Lightgray, Lightred, Blue);
  Window_Titre (Chaine, White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Affic_Center_Ln ('1 - Oui');
  Affic_Center_Ln ('2 - Non');
  Affic_Center ('Votre choix ? ');
  If (Defaut)
  Then
    Write ('1')
  Else
    Write ('2')
  {endif};
  While (Keypressed) Do
    Carac := Readkey
  {endwhile};
  Repeat
    Carac := Readkey
  Until ((Carac = Cr) Or (Carac = '1') Or (Carac = '2'));
  Clear_Window;
  Question_Oui_Non := ((Carac = '1') Or ((Carac = Cr) And Defaut));
  While (Keypressed) Do
    Carac := Readkey
  {endwhile}
End; { question_oui_non }

Function Int_Str (Nb : Integer) : String;
Var I      : Integer;
    Chaine : String;
Begin { int_str }
  Chaine := '';
  Repeat
    I := Nb Mod 10;
    Nb := Nb Div 10;
    Insert (Chr (48+I), Chaine, 1)
  Until (Nb = 0);
  Int_Str := Chaine
End; { int_str }

Function Saisie_Nombre (Chaine : String; Defaut, Min, Max : Integer) : Integer;
Var Carac : Char;
    Nb    : Integer;
Begin { saisie_nombre }
  Type_Cadre := 7;
  Window_Fond_Cadre_Bis (2, 2, 79, 4, Lightgray, Lightred, Blue);
  Window_Titre (Chaine, White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Affic_Center_Ln (Concat ('Minimum: ', Int_Str (Min), ', Maximum: ', Int_Str (Max), '.'));
  Affic_Center_Ln ('"+" pour augmenter, "-" pour diminuer.');
  While (Keypressed) Do
    Carac := Readkey
  {endhwile};
  If (Defaut < Min)
  Then
    Defaut := Min
  Else
    If (Defaut > Max)
    Then
      Defaut := Max
    {endif}
  {endif};
  Nb := Defaut;
  Repeat
    Delline;
    Affic_Center (Concat ('Nombre : ', Int_Str (Nb)));
    Carac := Readkey;
    Case Carac Of
      '+' : If (Nb < Max)
            Then
              Inc (Nb)
            Else
              Write (Bell)
            {endif};
      '-' : If (Nb > Min)
            Then
              Dec (Nb)
            Else
              Write (Bell)
            {endif}
    End;
  Until (Carac = Cr);
  While (Keypressed) Do
    Carac := Readkey
  {endwhile};
  Clear_Window;
  Saisie_Nombre := Nb
End; { saisie_nombre }

Function Saisir_Ligne (Chaine : String) : String;
Var Ligne : String;
Begin { saisir_ligne }
  Type_Cadre := 2;
  Window_Fond_Cadre_Bis (2, 2, 79, 4, Lightgray, Lightred, Blue);
  Window_Titre (Chaine, White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Repeat
    Clrscr;
    Readln (Ligne)
  Until (Ligne <> '');
  Clear_Window;
  Saisir_Ligne := Ligne
End; { saisir_ligne }

Procedure Ecrit (Var Fichier : Text; Chaine : String);
Begin { ecrit }
  Writeln (Chaine);
  Writeln (Fichier, Chaine)
End; { ecrit }

Procedure Fabrication_Menu (Var Texte : T_Ecran; Var Fich : T_Fich; Esc : Boolean; Nb_Opt : Integer);
Var I       : Integer;
    Fichier : Text;
Begin { fabrication_menu }
  Type_Cadre := 2;
  Window_Fond_Cadre_Bis (2, 2, 79, 23, Lightgray, Lightred, Blue);
  Window_Titre (Concat ('Sauvegarde du menu: ', Nom_Fichier), White, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
  Cree_Bak (Nom_Fichier);
  Assign (Fichier, Nom_Fichier);
  Rewrite (Fichier);
  Ecrit (Fichier, 'echo off');
  Ecrit (Fichier, 'cls');
  Ecrit (Fichier, Concat ('echo ', Texte [1]));
  Ecrit (Fichier, Concat ('echo ', Chr (255)));
  For I := 1 To Nb_Opt Do
    Ecrit (Fichier, Concat ('echo ', Chr (Pred (Ord ('A'))+I), ' - ', Texte [I+2]))
  {endfor};
  Ecrit (Fichier, Concat ('echo ', Texte [Nb_Opt+3], Chr (255)));
  Ecrit (Fichier, Concat ('echo ', Texte [Nb_Opt+4]));
  Ecrit (Fichier, ':debut');
  Ecrit (Fichier, 'choix');
  If (Esc)
  Then
    Ecrit (Fichier, 'if errorlevel 27 if not errorlevel 28 goto fin')
  {endif};
  Ecrit (Fichier, 'if not errorlevel 65 goto debut');
  Ecrit (Fichier, Concat ('if errorlevel ', Int_Str (Nb_Opt+Ord ('A')), ' goto debut'));
  For I := Nb_Opt Downto 1 Do
    Ecrit (Fichier, Concat ('if errorlevel ', Int_Str (I+Pred (Ord ('A'))), ' goto ', Chr (I+Pred (Ord ('A')))))
  {endfor};
  Ecrit (Fichier, 'goto debut');
  For I := 1 To Nb_Opt Do
    Begin
      Ecrit (Fichier, Concat (':', Chr (I+Pred (Ord ('A')))));
      Ecrit (Fichier, Fich [I+2]);
      Ecrit (Fichier, 'goto fin')
    End
  {endfor};
  Ecrit (Fichier, ':fin');
  Ecrit (Fichier, 'echo on');
  Ecrit (Fichier, 'cls');
  Ecrit (Fichier, 'exit');
  Close (Fichier);
  Clear_Window
End; { fabrication_menu }

Procedure Traitement;
Var Chaine : T_Ligne;
    Texte  : T_Ecran;
    Fich   : T_Fich;
    Esc    : Boolean;
    I,
    Nb_Opt : Integer;
Begin { traitement }
  Clear_Screen;
  Type_Cadre := 8;
  Window_Fond_Cadre_Bis (2, 10, 79, 20, Lightgray, Lightred, Blue);
  Window_Titre ('Saisie des donn‚es du menu.', White+Blink, Blue);
  Textcolor (Lightblue);
  Textbackground (Lightgray);
{ Saisie du nom du fichier. }
  Write_String (1, 1, 'Quel est le nom du fichier de menu ?');
  Display_Bloc_Horiz (1, 1, 78, 1);
  Ask_Nom_Fichier (Nom_Fichier);
  Write_String (38, 1, Nom_Fichier);
{ Pr‚sence de la ligne "ESC - Sortir du menu." }
  Write_String (1, 2, 'Voulez-vous le pr‚sence de la ligne: " ESC - Sortir du menu " dans votre');
  Write_String (1, 3, 'menu ?');
  Display_Bloc_Horiz (1, 1, 78, 3);
  Esc := Question_Oui_Non ('Possibilit‚ de sortir du menu par ESC ?', True);
  If (Esc)
  Then
    Chaine := 'Oui'
  Else
    Chaine := 'Non'
  {endif};
  Write_String (8, 3, Chaine);
{ Saisie du nombre d'options du menu. (entre 2 et 20) }
  Write_String (1, 4, 'Combien d''options voulez-vous dans ce menu ?');
  Display_Bloc_Horiz (1, 3, 78, 4);
  Nb_Opt := Saisie_Nombre ('Nombre d''options ?', 2, 2, 20);
  Write_String (46, 4, Int_Str (Nb_Opt));
{ Saisie du titre du menu. }
  Write_String (1, 5, 'Quel est le titre du menu ? (premiŠre ligne de l''‚cran)');
  Display_Bloc_Horiz (1, 4, 78, 5);
  Texte [1] := Saisir_Ligne ('Titre du menu');
  Write_String (1, 6, Concat ('"', Texte [1], '"'));
  Display_Bloc_Horiz (1, 6, 78, 6);
{ Saisie des options et des fichiers associ‚s. }
  For I := 1 To Nb_Opt Do
    Repeat
      Clear_Bloc (1, 8, 79, 10);
      Write_String (1, 8, Concat ('Titre de l''option: ', Int_Str (I)));
      Display_Bloc_Horiz (1, 8, 78, 8);
      Texte [I+2] := Saisir_Ligne (Concat ('Titre de l''option: ', Int_Str (I)));
      Write_String (1, 9, Concat ('"', Texte [I+2], '"'));
      Write_String (1, 10, 'Nom du fichier associ‚: ');
      Display_Bloc_Horiz (1, 9, 78, 10);
      Fich [I+2] := Saisir_Ligne (Concat ('Fichier de l''option: ', Int_Str (I)));
      Write_String (24, 10, Fich [I+2]);
      Display_Bloc_Horiz (1, 10, 78, 10);
      Gotoxy (1, 1);
      Delline;
      Delline;
      Delline
    Until (Question_Oui_Non ('Validation ?', True))
  {endfor};
{ Fin du chargement des donn‚es. }
  If (Esc)
  Then
    Texte [Nb_Opt+3] := 'ESC - Quitter le menu.'
  {endif};
  Texte [Nb_Opt+4] := 'Votre choix ?';
  Fabrication_Menu (Texte, Fich, Esc, Nb_Opt);
  Reset_Screen
End; { traitement }

Begin { make_menu }
      init_licence ('MKBAT');
      init_olf_message (mess_careware);
      init_olf_software ('Menu Maker '+num_ver, '(c) Patrick Pr‚martin '+dat_ver);
  Reset_Screen;
  Clear_Screen;
  Initialisation;
  Presentation;
  Repeat
    Reset_Screen;
    Clear_Screen;
    Traitement
  Until (Question_Oui_Non ('Voulez-vous arreter ?', True));
  Reset_Screen;
  Clear_Screen;
  Writeln ('Au revoir et … bientot...')
End. { make_menu }
