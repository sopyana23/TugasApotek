program DataApotek;
uses crt,sysutils;
const
     maks=100;
     maksPinjaman=1000;
     maks_menu=12;
     garis_kiri=5;
     garis_kanan=60;
     garis_atas=3;
     garis_bawah=17;
     atas=#72;
     bawah=#80;
     enter=#13;
     kiri=#75;
     kanan=#77;
type

    Obat=record
                id_obat:string;
                nama_obat:string;
                jenis:string;
                harga:integer;
                stok:integer;
    end;

    PDataObat=^TDataObat;
    TDataObat=record
                    info:Obat;
                    next,prev:PDataObat;
     end;
//----------------------------------------------------------------------------------------------------------------------

    data_menu=array[1..maks_menu] of string;



//global Variable
var
   SRecObat:Obat;
   awal,akhir:PDataObat;
   banyakObat:integer;

   Tmenu:data_menu;
   bd,bdpinjam,pil:integer;
   YYYY,MM,DD : Word;




//----------------------------------------------------------------------------------------------------------------------
//FRAME
//----------------------------------------------------------------------------------------------------------------------
procedure kotak(kiri,kanan,atas,bawah:integer;
                latar,tulisan:integer;judul:string);
var
   i:integer;
begin
     textcolor(tulisan);textbackground(latar);
     window(kiri,atas,kanan,bawah);
     clrscr;
     window(1,1,120,30);
     gotoxy(kiri,atas);write(chr(218));
     gotoxy(kanan,atas);write(chr($BF));
     gotoxy(kiri,bawah);write(#192);
     gotoxy(kanan,bawah);write(#217);
     for i:=kiri+1 to kanan-1 do
     begin
          gotoxy(i,atas);write(#196);gotoxy(i,bawah);write(#196);
     end;
     for i:=atas+1 to bawah-1 do
     begin
          gotoxy(kiri,i);write(#179);gotoxy(kanan,i);write(#179);
     end;
     gotoxy(((kanan-kiri)-length(judul)) div 2+kiri, atas+1);write(judul);
end;

procedure pemisah(kiri,kanan,atas:integer);
var
   i:integer;
begin
     gotoxy(kiri,atas);write(#195);
     for i:=kiri+1 to kanan-1 do
     begin
          gotoxy(i,atas);write(#196);
     end;
     gotoxy(kanan,atas);write(#180);
     writeln;
end;

procedure bersihin();
begin
     textcolor(0);textbackground(0);
     window(1,1,120,30);
     clrscr;
end;

//----------------------------------------------------------------------------------------------------------------------




procedure penciptaan(var awal,akhir:PDataObat);
begin
     awal:=nil;
     akhir:=nil;
end;


//----------------------------------------------------------------------------------------------------------------------
//Hitung Banyak DATA Obat
//----------------------------------------------------------------------------------------------------------------------
 procedure hitungbdObat;
 var
    bantu:PDataObat;
 begin
      bantu:=awal;
          banyakObat :=1;
          while bantu<>akhir do
          begin
               bantu:=bantu^.next;
               banyakObat:=banyakObat+1;
          end;
 end;
//----------------------------------------------------------------------------------------------------------------------



//----------------------------------------------------------------------------------------------------------------------
//tambah data obat
//----------------------------------------------------------------------------------------------------------------------
Procedure TambahRecordObat(info : obat; id_obat, nama_obat, jenis : String; harga, stok : Integer);
Begin
     SRecObat.id_obat   := id_obat;
     SRecObat.nama_obat := nama_obat;
     SRecObat.jenis     := jenis;
     SRecObat.harga     := harga;
     SRecObat.stok      := stok;
End;

procedure sisipdepanObat(var awal,akhir:PDataObat;data:Obat);
var
   baru:PDataObat;
begin
     new(baru);
     baru^.info:=data;
     baru^.next:=nil;
     baru^.prev:=nil;
     if awal=nil then
     begin
          akhir:=baru;
     end
     else
     begin
          baru^.next:=awal;
          awal^.prev:=baru;

     end;
     awal := baru;
      akhir^.next := awal;
      awal^.prev := akhir;
end;

procedure sisipbelakangObat(var awal,akhir:PDataObat;data:Obat);
var
   baru:PDataObat;
begin
     new(baru);
     baru^.info := data;   
     baru^.next:=nil;
     baru^.prev:=nil;
     if (awal = nil) then
        sisipdepanObat(awal,akhir,data)
     else
         begin
           akhir^.next := baru;
           baru^.prev := akhir;
           akhir := baru;
           akhir^.next := awal;
           awal^.prev := akhir;
         end;
end;
procedure pengurutan(awal,akhir:PDataObat);
var
   i,j,min:PDataObat;
   temp:string;
begin
     if awal=nil then
        writeln('Data Masih Kosong')
     else
     if awal=akhir then
        writeln('Data cuma 1')
     else
     begin
          i:=awal;
          while i^.next<>akhir do
          begin
               min:=i;
               j:=i^.next;
               while j<>nil do
               begin
                    if j^.info.id_obat<min^.info.id_obat then
                       min:=j;
                    j:=j^.next;
               end;
               if i<>min then
               begin
                    temp:=i^.info.id_obat;
                    i^.info:=min^.info;
                    min^.info.id_obat:=temp;
               end;
               i:=i^.next;
          end;
     end;
end;



procedure tambah_Obat;
var
   Rid_obat,Rnama_obat,Rjenis:string;
   Rharga,Rstok:integer;

begin
     clrscr;
     bersihin;
          kotak(4,50,2,20,BLUE,WHITE,'Tambah Data Obat');
          pemisah(4,50,4);





          gotoxy(6,5);writeln('Masukan Data Obat ');
          gotoxy(6,6);write('id Obat    : ');readln(Rid_obat);
          gotoxy(6,7);write('Nama Obat  : ');readln(Rnama_obat);
          gotoxy(6,8);write('Jenis      : ');readln(Rjenis);
          gotoxy(6,9);write('Harga      : ');readln(Rharga);
          gotoxy(6,10);write('Stok      : ');readln(Rstok);

          TambahRecordObat(SRecObat,Rid_obat,Rnama_obat,Rjenis,Rharga,Rstok);
          sisipdepanObat(awal,akhir,SRecObat);

          gotoxy(6,12);write('Data berhasil Disimpan');


          gotoxy(6,16);write('Tekan enter untuk kembali ke menu');
          read;

end;
//----------------------------------------------------------------------------------------------------------------------






//----------------------------------------------------------------------------------------------------------------------
//TAMPIL DATA Obat
//----------------------------------------------------------------------------------------------------------------------
procedure tampil_dataObat(awal,akhir:PDataObat);
var
   i,j,y : integer;
   bantu:PDataObat;
begin
     bersihin;
     clrscr;
     kotak(1,120,1,30,BLUE,WHITE,'Data Obat');
     pemisah(1,120,3);
     //                                   1234567890123456789012        1234567890123      1234567890123456       12345678901234
     gotoxy(4,4);writeln(' ID Obat ',#179,'      Nama Obat      ',#179,'    Jenis   ',#179,'    Harga    ',#179,'  Stok  ',#179);
     
     if awal=nil then
     begin
          write('Data Kosong. Tekan Enter Untuk Kembali !');
     end
     else
     begin
          hitungbdObat;
          bantu:=awal;
          y:=1;
          for i:=1 to banyakObat do
          begin
               bantu:=bantu^.next;
               gotoxy(4,4+y);
               writeln(' ',bantu^.info.id_obat:7,' ',#179,' ',bantu^.info.nama_obat:19,' ',#179,' ',bantu^.info.jenis:10,' ',#179,' Rp.',bantu^.info.harga:8,' ',#179,' ',bantu^.info.stok:5,'  ',#179);
               y:=y+1;
          end;

          pemisah(1,120,27);
          gotoxy(4,28);write('Jumlah Obat : ',banyakObat);
          gotoxy(4,29);write('Tekan enter untuk kembali ke menu                                                        !note : Jangan di maximize');
     end;
     read;
end;

//----------------------------------------------------------------------------------------------------------------------








//----------------------------------------------------------------------------------------------------------------------
//UBAH DATA Obat
//----------------------------------------------------------------------------------------------------------------------
var
   terpilih:integer;
   tombol:char;

procedure tulis_menuUbahObat(awal,akhir:PDataObat);
var
   i,y:integer;
   bantu:PDataObat;
begin
     bersihin;
     kotak(4,40,2,20,BLUE,WHITE,'Ubah Data Obat');
     pemisah(4,40,4);
     if awal=nil then
     begin
          gotoxy(4,6);write('Data Kosong. Tekan Enter Untuk Kembali !');
     end
     else
     begin
          gotoxy(5,5);writeln('Pilih Data yang mau diubah');
          gotoxy(8,7);writeln(' ID Obat ',#179,'  Nama Obat  ');
          hitungbdObat;
          bantu:=awal;
          y:=1;
          for i:=1 to banyakObat do
          begin
              if terpilih = i then
              begin
                   textbackground(4);

                   bantu:=bantu^.next;
                   gotoxy(8,7+y);writeln(' ',bantu^.info.id_obat:7,' ',#179,' ',bantu^.info.nama_obat);
                   y:=y+1;
              end
              else
              begin
                   textbackground(blue);
                   bantu:=bantu^.next;
                   gotoxy(8,7+y);writeln(' ',bantu^.info.id_obat:7,' ',#179,' ',bantu^.info.nama_obat);
                   y:=y+1
              end;
              end;

     end;


end;

procedure ubah_Anggota(index:integer);
var
   nama,id_obat,jenis:string;
   harga,stok:integer;
   bantu:PDataObat;
   j,i:integer;
   Rid_obat,Rnama_obat,Rjenis:string;
   Rharga,Rstok:integer;
   ketemu : boolean;
begin
     bersihin;
     kotak(4,65,2,20,BLUE,WHITE,'Ubah Data Anggota');
     pemisah(4,65,4);

     bantu:=awal;
     for i:=1 to index do
          begin
               bantu:=bantu^.next;
               id_obat:=bantu^.info.id_obat;
               nama:=bantu^.info.nama_obat;
               jenis:=bantu^.info.jenis;
               harga:=bantu^.info.harga;
               stok:=bantu^.info.stok;
          end;


     gotoxy(5,5);writeln('Data yang Mau Di Ubah ID Obat : ',id_obat);
     gotoxy(5,6);writeln('Kosongkan yang tidak diubah');
     gotoxy(5,8);write('Nama       : ',nama,'   Ubah  : ');readln(Rnama_obat);
     gotoxy(5,9);write('Jenis     : ',jenis,'   Ubah  : ');readln(Rjenis);
     gotoxy(5,10);write('Harga : ',harga,'   Ubah  : ');readln(Rharga);
     gotoxy(5,11);write('Stok  : ',stok,'   Ubah  : ');readln(Rstok);

     ketemu := false;
     bantu := awal;
     while (ketemu = false) and (bantu <> akhir) do
                 if (bantu^.info.id_obat = id_obat) then
                    ketemu := true
                 else
                     bantu := bantu^.next;
                 if (ketemu = true) then
                 begin
                      if Rnama_obat<>'' then
                         bantu^.info.nama_obat:=Rnama_obat;
                      if Rjenis<>'' then
                         bantu^.info.jenis:=Rjenis;
                      if IntToStr(Rharga)<>'' then
                         bantu^.info.harga:=Rharga;
                      if IntToStr(Rstok)<>'' then
                         bantu^.info.stok:=Rstok;
                 end;


     gotoxy(5,15);write('Data berhasil Di Ubah');
     gotoxy(5,16);write('Tekan enter untuk kembali ke menu');
     read;

end;

procedure pilih_ObatUbah;
var
   i:integer;
begin
     terpilih:=1;
     hitungbdObat;
     repeat
     clrscr;
     tulis_menuUbahObat(awal,akhir);

     tombol:=readkey;
     if tombol=bawah then
     begin
          if terpilih <> banyakObat then
             terpilih:=terpilih+1;
     end

     else if tombol=atas then
     begin
          terpilih:=terpilih-1;
          if terpilih = 0 then
             terpilih:=terpilih+1;
     end
     else if tombol=enter then
     begin
          clrscr;
          ubah_Anggota(terpilih);
     end;


     //readln(i);
     //terpilih:=i;
     until tombol=enter;
end;

//----------------------------------------------------------------------------------------------------------------------




//----------------------------------------------------------------------------------------------------------------------
//Hapus DATA Obat
//----------------------------------------------------------------------------------------------------------------------
var
   terpilih2:integer;
procedure tulis_menuHapusObat(awal,akhir:PDataObat);
var
   i,y:integer;
   bantu:PDataObat;
begin
     bersihin;
     kotak(4,40,2,20,BLUE,WHITE,'Hapus Data Obat');
     pemisah(4,40,4);
     if awal=nil then
     begin
          gotoxy(4,6);write('Data Kosong. Tekan Enter Untuk Kembali !');
     end
     else
     begin
          gotoxy(5,5);writeln('Pilih Data Obat yang mau di hapus');
          gotoxy(8,7);writeln(' ID Obat ',#179,' Nama Obat ');
          hitungbdObat;
          bantu:=awal;
          y:=1;
          for i:=1 to banyakObat do
          for i:=1 to banyakObat do
          begin
               if terpilih2 = i then
               begin
                    textbackground(4);
                    bantu:=bantu^.next;
                    gotoxy(8,7+y);writeln(' ',bantu^.info.id_obat:7,' ',#179,' ',bantu^.info.nama_obat);
                    y:=y+1;
               end
               else
               begin
                    textbackground(blue);
                    bantu:=bantu^.next;
                    gotoxy(8,7+y);writeln(' ',bantu^.info.id_obat:7,' ',#179,' ',bantu^.info.nama_obat);
                    y:=y+1
               end;
          end;
     end;
end;

procedure hapusdepan(var data:Obat;var awal,akhir:PDataObat);               //Prosedur Hapus Data Depan
begin
     if awal=nil then
        writeln('Data kosong, tidak ada yang dihapus')
     else
     if awal=akhir then
     begin
          data:=awal^.info;
          dispose(awal);
          awal:=nil;
          akhir:=nil;
     end
     else
     begin
          data:=awal^.info;
          awal:=awal^.next;
          dispose(awal^.prev);
          awal^.prev:=akhir;
          akhir^.next:=awal;
     end;
end;

procedure hapus_Obat(index:integer);
var
   yt:char;
   x,j,i:integer;
   phapus,bantu:PDataObat;
   ketemu : boolean;
   nama,id_obat,jenis:string;
   data:Obat;

begin
     bersihin;
     kotak(4,55,2,10,BLUE,WHITE,'Hapus Data Obat');
     pemisah(4,55,4);

     bantu:=awal;
     for i:=1 to index do
          begin
               bantu:=bantu^.next;
               id_obat:=bantu^.info.id_obat;
               nama:=bantu^.info.nama_obat;
          end;

     gotoxy(5,5);write('Hapus Data ID:',id_obat,'   Nama Obat : ',nama,' ?(y/t)');
     read(yt);
     if upcase(yt) = 'Y' then
     begin
          ketemu := false;
          bantu := awal;
          while (ketemu = false) and (bantu <> akhir) do
                 if (bantu^.info.id_obat = id_obat) then
                    ketemu := true
                 else
                     bantu := bantu^.next;
                 if (ketemu = true) then
                 begin

                      bantu^.next^.prev:=bantu^.prev;
                      bantu^.prev^.next:=bantu^.next;
                      bantu^.next:=nil;
                      bantu^.prev:=nil;
                      dispose(bantu);

                 end;
          gotoxy(5,7);write('Data Berhasil Dihapus');
     end
     else if upcase(yt) = 'T' then
     begin
          gotoxy(5,7);write('Hapus Dibatalkan');
     end;
     gotoxy(5,8);write('Tekan enter untuk kembali ke menu');
     readln;
end;

procedure pilih_ObatHapus;
var
   i:integer;
begin
     hitungbdObat;
     terpilih2:=1;
     repeat
     clrscr;
     tulis_menuHapusObat(awal,akhir);

     tombol:=readkey;
     if tombol=bawah then
     begin
          if terpilih2 <> banyakObat then
             terpilih2:=terpilih2+1;
     end

     else if tombol=atas then
     begin
          terpilih2:=terpilih2-1;
          if terpilih2 = 0 then
             terpilih2:=terpilih2+1;
     end
     else if tombol=enter then
     begin
          clrscr;
          hapus_Obat(terpilih2);
     end;


     //readln(i);
     //terpilih:=i;
     until tombol=enter;
end;


//----------------------------------------------------------------------------------------------------------------------







//----------------------------------------------------------------------------------------------------------------------
procedure simpansemuafile;
var
   f:file of Obat;
   bantu:PDataObat;
   i,j:integer;
begin
     assign(f,'DataObat.dat');
     rewrite(f);

     bantu:=awal;
     j :=1;
     while bantu<>akhir do
     begin
          bantu:=bantu^.next;
          j:=j+1;
     end;
     bantu:=awal;
     for i:=1 to j do
     begin
          bantu:=bantu^.next;
          write(f,bantu^.info);

     end;

     writeln(j,' Data Telah Disimpan Ke File');
     readln;
end;
//----------------------------------------------------------------------------------------------------------------------



//----------------------------------------------------------------------------------------------------------------------
procedure bacasemuafile;
var
   c:file of Obat;
   bantu:PDataObat;
   obatBaru:Obat;
   j:integer;
begin
     if fileexists('DataObat.dat') then
     begin
          assign(c,'DataObat.dat');
          reset(c);
          //write('test');
          penciptaan(awal,akhir);
          while not eof(c) do
          begin
               read(c,obatBaru);
               TambahRecordObat(SRecObat,obatBaru.id_obat,obatBaru.nama_obat,obatBaru.jenis,obatBaru.harga,obatBaru.stok);
               sisipdepanObat(awal,akhir,SRecObat);
          end;

          close(c);
           j :=1;
           bantu:=awal;
           while bantu<>akhir do
           begin
                bantu:=bantu^.next;
                j:=j+1;
           end;

          writeln('Baca data selesai. Terbaca ',j,' data');
     end
     else
     begin
          writeln('File Belum Ada. Tidak ada data yang terbaca');readln;
     end;

end;
//----------------------------------------------------------------------------------------------------------------------




//----------------------------------------------------------------------------------------------------------------------
//MENU
//----------------------------------------------------------------------------------------------------------------------
procedure isi_menu;
begin
     Tmenu[1]:=' 1. Tambah Obat       ';
     Tmenu[2]:=' 2. Tampil Data Obat    ';
     Tmenu[3]:=' 3. Pengurutan     ';
     Tmenu[4]:=' 4.      ';
     Tmenu[5]:=' 5. Ubah Data Obat        ';
     Tmenu[6]:=' 6. Hapus Data Obat         ';
     Tmenu[7]:=' 7.                   ';
     Tmenu[8]:=' 8.                  ';
     Tmenu[9]:=' 9.             ';
     Tmenu[10]:=' 10.  ';
     Tmenu[11]:=' 11. Simpan Ke File      ';
     Tmenu[12]:=' 12. Keluar                   ';
end;

procedure tulis_menu;
var
   i:integer;
begin
for i:=1 to maks_menu do
     begin
          if terpilih = i then
          begin
               textbackground(4);
               writeln(Tmenu[i]);
          end
          else
          begin
               textbackground(blue);
               writeln(Tmenu[i]);

          end;

     end;
end;

procedure buka_menu(t:integer);
begin
     case t of
          1:tambah_Obat;
          2:tampil_dataObat(awal,akhir);
          3:pengurutan(awal,akhir);
          4:;
          5:pilih_ObatUbah;
          6:pilih_ObatHapus;
          7:;
          8:;
          9:;
          10:;
          11:simpansemuafile;
     end;
end;

procedure seleksi_menu;
begin
     terpilih:=1;
     repeat
           clrscr;
           isi_menu;
           tulis_menu;

           tombol:=readkey;
           if tombol=bawah then
           begin
                if terpilih <> maks_menu then
                   terpilih:=terpilih+1;
           end
           else if tombol=atas then
           begin
                terpilih:=terpilih-1;
                if terpilih = 0 then
                   terpilih:=terpilih+1;
           end
           else if tombol=enter then
           begin
                clrscr;
                buka_menu(terpilih);
           end;

     until tombol=enter;
end;


procedure testisi;
begin

     TambahRecordObat(SRecObat,'005','Alkohol','botol',30000,70);
     sisipdepanObat(awal,akhir,SRecObat);
     TambahRecordObat(SRecObat,'006','Antimo','tablet',2500,89);
     sisipdepanObat(awal,akhir,SRecObat);
     TambahRecordObat(SRecObat,'007','parah','botol',7500,7);
     sisipdepanObat(awal,akhir,SRecObat);

end;



//----------------------------------------------------------------------------------------------------------------------

//----------------------------------------------------------------------------------------------------------------------
//mulai disini
//----------------------------------------------------------------------------------------------------------------------
begin
penciptaan(awal,akhir);

     bd:=0;
     bdpinjam:=0;
     bacasemuafile;

     testisi;

     readln;

     repeat
     bersihin;
     clrscr;

     kotak(3,55,2,20,BLUE,WHITE,'Aplikasi Apotek');
     pemisah(3,55,4);



     kotak(78,113,2,9,Blue,White,'Catatan');
     pemisah(78,113,4);
     window(79,5,112,8);
     writeln('-Gunakan arrow key atas dan bawah');
     writeln(' untuk pindah menu');
     writeln('-Tekan Enter Untuk Memilih');


     window(5,5,52,19);
     seleksi_menu;

     readln;
     until terpilih=12;

     read;
end.

