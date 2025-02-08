clc
clear all
close all

%variables
prom_bordes_n = 0;
prom_bordes_a = 0;
prom_sombra_n = 0;
prom_sombra_a = 0;
prom_rojo_n = 0;
prom_rojo_a = 0;


directorio_principal = 'imagenes';% Directorio donde están las carpetas "normales" y "anormales"
cd(fullfile(directorio_principal, 'normales'));% Cambiar al directorio "normales"
p = dir('*.jpg');% Obtener la lista de archivos JPEG en el directorio "normales"
tam = length(p);

for i = 1:tam
    nombre = p(i).name;
    I = imread(fullfile(pwd, nombre));% Leer la imagen utilizando la ruta completa


    %mascara 
    Ig = rgb2gray(I);
    Ie= histeq(Ig);%ecualizaciond el histograma
    level = 100/256;% Aplica el método de Otsu para obtener el umbral óptimo
    BW = imbinarize(Ie, level);% Binariza la imagen utilizando el umbral óptimo
    mascara = repmat(BW, [1, 1, size(I, 3)]);% Crea una máscara de la región de interés
    
    


    % Obtener los canales de color de la imagen (RGB)
    canal_rojo = I(:,:,1); % Canal rojo
    canal_verde = I(:,:,2); % Canal verde
    canal_azul = I(:,:,3); % Canal azul  
    % Definir umbrales para cada componente de color
    umbral_rojo = 100; % Umbral para el componente rojo
    umbral_verde = 100; % Umbral para el componente verde
    umbral_azul = 100; % Umbral para el componente azul
    % Crear máscaras lógicas para identificar los píxeles rojos, verdes y azules
    mascara_roja = canal_rojo > umbral_rojo;
    mascara_verde = canal_verde < umbral_verde;
    mascara_azul = canal_azul < umbral_azul;   
    % Combinar las máscaras en una única máscara
    mascara_total = mascara_roja & mascara_verde & mascara_azul; 
    % Contar el número de píxeles rojos
    num_pixeles_rojos = sum(mascara_total(:)); 
    % Crear una imagen en blanco y negro con los píxeles rojos en blanco y los no rojos en negro
    Ir = zeros(size(I, 1), size(I, 2));
    Ir(mascara_total) = 1;




    
    I_eq = im2double(Ie);% Normalizar la imagen en el rango [0, 1]
    % Aplicar un ajuste local del contraste para resaltar las sombras
    radius = 15; % Radio de la ventana local
    amount = 0.5; % Cantidad de ajuste local
    I_shadow = adapthisteq(I_eq, 'NumTiles', [8 8], 'ClipLimit', amount, 'NBins', 256, 'Distribution', 'rayleigh');%ajuste local de contraste
    umbral_sombra = 0.5;% Definir el umbral para considerar sombras 
    I4 = I_shadow < umbral_sombra;% Crear una máscara binaria para identificar los píxeles sombra
    %I4 = bwlabel(I4);
    num_sombra = sum(I4(:));% Contar la cantidad de píxeles sombra



    
    I2 = edge(Ie, 'log');% Aplicar el operador Laplaciano
    I3 = I2 .* mascara;% Aplica la máscara a la imagen de bordes para descartar bordes que no sean de la piel
    %I3 = bwlabel(I3);
    num_bordes = sum(I3(:)); % Calcular el número de bordes detectados

    %mostrar
    %figure, 
    %subplot(2,2,1);
    %imshow(Ie), title('Imagen mejora contraste');
    %subplot(2,2,2);
    %imshow(Ir), title('deteccion rojos');
    %subplot(2,2,3);
    %imshow(I3), title('deteccion bordes');
    %subplot(2,2,4);
    %imshow(I4), title('deteccion sombras');


    prom_bordes_n=prom_bordes_n + num_bordes;
    prom_rojo_n=prom_rojo_n+num_pixeles_rojos;
    prom_sombra_n=prom_sombra_n+num_sombra;

    
    %disp(['Número de bordes en ' nombre ': ' num2str(num_bordes)]);% Mostrar el número de bordes

end

prom_bordes_n = prom_bordes_n/tam;
prom_rojo_n=prom_rojo_n/tam;
prom_sombra_n=prom_sombra_n/tam;
disp(['promedio de bordes normal:' num2str(prom_bordes_n)]);
disp(['promedio de sombras normal:' num2str(prom_sombra_n)]);
disp(['promedio de rojos normal:' num2str(prom_rojo_n)  ' ' newline ]);


cd('..');
cd('anormales');% Cambiar al directorio "anormales"
p1 = dir('*.jpg');% Obtener la lista de archivos JPEG en el directorio "anormales"
tam1 = length(p1);

for i = 1:tam1
    nombre = p1(i).name;
    I = imread(fullfile(pwd, nombre));% Leer la imagen utilizando la ruta completa

    %mascara 
    Ig = rgb2gray(I);
    Ie= histeq(Ig);%ecualizaciond el histograma
    level = 100/256;% Aplica el método de Otsu para obtener el umbral óptimo
    BW = imbinarize(Ie, level);% Binariza la imagen utilizando el umbral óptimo
    mascara = repmat(BW, [1, 1, size(I, 3)]);% Crea una máscara de la región de interés
    
    


    % Obtener los canales de color de la imagen (RGB)
    canal_rojo = I(:,:,1); % Canal rojo
    canal_verde = I(:,:,2); % Canal verde
    canal_azul = I(:,:,3); % Canal azul  
    % Definir umbrales para cada componente de color
    umbral_rojo = 120; % Umbral para el componente rojo
    umbral_verde = 80; % Umbral para el componente verde
    umbral_azul = 80; % Umbral para el componente azul
    % Crear máscaras lógicas para identificar los píxeles rojos, verdes y azules
    mascara_roja = canal_rojo > umbral_rojo;
    mascara_verde = canal_verde < umbral_verde;
    mascara_azul = canal_azul < umbral_azul;   
    % Combinar las máscaras en una única máscara
    mascara_total = mascara_roja & mascara_verde & mascara_azul; 
    % Contar el número de píxeles rojos
    num_pixeles_rojos = sum(mascara_total(:)); 
    % Crear una imagen en blanco y negro con los píxeles rojos en blanco y los no rojos en negro
    Ir = zeros(size(I, 1), size(I, 2));
    Ir(mascara_total) = 1;
    %Ir = bwlabel(Ir);


    I_eq = im2double(Ie);% Normalizar la imagen en el rango [0, 1]
    % Aplicar un ajuste local del contraste para resaltar las sombras
    radius = 15; % Radio de la ventana local
    amount = 0.5; % Cantidad de ajuste local
    I_shadow = adapthisteq(I_eq, 'NumTiles', [8 8], 'ClipLimit', amount, 'NBins', 256, 'Distribution', 'rayleigh');%ajuste local de contraste
    umbral_sombra = 0.5;% Definir el umbral para considerar sombras 
    I4 = I_shadow < umbral_sombra;% Crear una máscara binaria para identificar los píxeles sombra
    %I4 = bwlabel(I4);
    num_sombra = sum(I4(:));% Contar la cantidad de píxeles sombra


    I2 = edge(Ie, 'log');% Aplicar el operador Laplaciano
    I3 = I2 .* mascara;% Aplica la máscara a la imagen de bordes para descartar bordes que no sean de la piel
    %I3 = bwlabel(I3);
    num_bordes = sum(I3(:)); % Calcular el número de bordes detectados


    %mostrar
    %figure, 
    %subplot(2,2,1);
    %imshow(Ie), title('Imagen mejora contraste');
    %subplot(2,2,2);
    %imshow(Ir), title('deteccion rojos');
    %subplot(2,2,3);
    %imshow(I3), title('deteccion bordes');
    %subplot(2,2,4);
    %imshow(I4), title('deteccion sombras');

    prom_bordes_a=prom_bordes_a + num_bordes;
    prom_rojo_a=prom_rojo_a+num_pixeles_rojos;
    prom_sombra_a=prom_sombra_a+num_sombra;
    


    % Mostrar el número de bordes
    %disp(['Número de bordes en ' nombre ': ' num2str(num_bordes)]);


end

prom_bordes_a = prom_bordes_a/tam1;
prom_rojo_a=prom_rojo_a/tam1;
prom_sombra_a=prom_sombra_a/tam1;
disp(['promedio de bordes anormal:' num2str(prom_bordes_a)]);
disp(['promedio de sombras anormal:' num2str(prom_sombra_a)]);
disp(['promedio de rojos anormal:' num2str(prom_rojo_a) ' ' newline] );


cd('..');
%pruebas
cd('pruebas');
% Obtener la lista de archivos JPEG en el directorio "pruebas"
p2 = dir('*.jpg');
tam2 = length(p2);

for i = 1:tam2
    nombre = p2(i).name;
    I = imread(fullfile(pwd, nombre));% Leer la imagen utilizando la ruta completa

    %mascara 
    Ig = rgb2gray(I);
    Ie= histeq(Ig);%ecualizaciond el histograma
    level = 100/256;% Aplica el método de Otsu para obtener el umbral óptimo
    BW = imbinarize(Ie, level);% Binariza la imagen utilizando el umbral óptimo
    mascara = repmat(BW, [1, 1, size(I, 3)]);% Crea una máscara de la región de interés


    % Obtener los canales de color de la imagen (RGB)
    canal_rojo = I(:,:,1); % Canal rojo
    canal_verde = I(:,:,2); % Canal verde
    canal_azul = I(:,:,3); % Canal azul  
    % Definir umbrales para cada componente de color
    umbral_rojo = 120; % Umbral para el componente rojo
    umbral_verde = 80; % Umbral para el componente verde
    umbral_azul = 80; % Umbral para el componente azul
    % Crear máscaras lógicas para identificar los píxeles rojos, verdes y azules
    mascara_roja = canal_rojo > umbral_rojo;
    mascara_verde = canal_verde < umbral_verde;
    mascara_azul = canal_azul < umbral_azul;   
    % Combinar las máscaras en una única máscara
    mascara_total = mascara_roja & mascara_verde & mascara_azul; 
    % Contar el número de píxeles rojos
    num_pixeles_rojos = sum(mascara_total(:)); 
    % Crear una imagen en blanco y negro con los píxeles rojos en blanco y los no rojos en negro
    Ir = zeros(size(I, 1), size(I, 2));
    Ir(mascara_total) = 1;
    %Ir = bwlabel(Ir);


    I_eq = im2double(Ie);% Normalizar la imagen en el rango [0, 1]
    % Aplicar un ajuste local del contraste para resaltar las sombras
    radius = 15; % Radio de la ventana local
    amount = 0.5; % Cantidad de ajuste local
    I_shadow = adapthisteq(I_eq, 'NumTiles', [8 8], 'ClipLimit', amount, 'NBins', 256, 'Distribution', 'rayleigh');%ajuste local de contraste
    umbral_sombra = 0.5;% Definir el umbral para considerar sombras 
    I4 = I_shadow < umbral_sombra;% Crear una máscara binaria para identificar los píxeles sombra
    %I4 = bwlabel(I4);
    num_sombra = sum(I4(:));% Contar la cantidad de píxeles sombra



    I2 = edge(Ie, 'log');% Aplicar el operador Laplaciano
    I3 = I2 .* mascara;% Aplica la máscara a la imagen de bordes para descartar bordes que no sean de la piel
    %I3 = bwlabel(I3);
    num_bordes = sum(I3(:)); % Calcular el número de bordes detectados


    %mostrar
    figure, 
    subplot(2,2,1);
    imshow(Ie), title('Imagen mejora contraste');
    subplot(2,2,2);
    imshow(Ir), title('deteccion rojos');
    subplot(2,2,3);
    imshow(I3), title('deteccion bordes');
    subplot(2,2,4);
    imshow(I4), title('deteccion sombras');
    

    % Mostrar el número de bordes
    disp(['Número de bordes en ' nombre ': ' num2str(num_bordes)]);
    disp(['Número de rojos en ' nombre ': ' num2str(num_pixeles_rojos)]);
    disp(['Número de sombras en ' nombre ': ' num2str(num_sombra)]);


    Bdistancia_n=abs(prom_bordes_n -num_bordes);
    Bdistancia_a=abs(prom_bordes_a -num_bordes);
    Rdistancia_n=abs(prom_rojo_n -num_pixeles_rojos);
    Rdistancia_a=abs(prom_rojo_a -num_pixeles_rojos);
    Sdistancia_n=abs(prom_sombra_n - num_sombra);
    Sdistancia_a=abs(prom_sombra_a - num_sombra);


    distancia_n=sqrt((Rdistancia_n^2)+(Bdistancia_n^2)+(Sdistancia_n^2));
    distancia_a=sqrt((Rdistancia_a^2)+(Bdistancia_a^2)+(Sdistancia_a^2));


    if(Bdistancia_n < Bdistancia_a)
        disp(['La imagen ' nombre ' es clasificada como  normal por bordes']);
    else
        disp(['La imagen ' nombre ' es clasificada como  anormal por bordes']);        
    end

    if(Rdistancia_n < Rdistancia_a)
        disp(['La imagen ' nombre ' es clasificada como  normal por rojos']);
    else
        disp(['La imagen ' nombre ' es clasificada como  anormal por rojos']);
    end


    if(Sdistancia_n < Sdistancia_a)
        disp(['La imagen ' nombre ' es clasificada como  normal por sombras']);
    else
        disp(['La imagen ' nombre ' es clasificada como  anormal por sombras']);
    end

    
    % Determinar posición del texto
    text_x = 0.5; % Posición central horizontal
    text_y = 0.01; % Posición en la parte inferior de la figura




    if(distancia_n < distancia_a)
        disp(['La imagen ' nombre ' es clasificada como  normal' newline]);
        annotation('textbox', [text_x, text_y, 0.1, 0.1], 'String', ['La piel es clasificada como  normal'], 'Color', 'green', 'FontSize', 14, 'LineStyle', 'none', 'HorizontalAlignment', 'center');
    else
        disp(['La imagen ' nombre ' es clasificada como  anormal ' newline]);
        annotation('textbox', [text_x, text_y, 0.1, 0.1], 'String', ['La piel es clasificada como  anormal'], 'Color', 'red', 'FontSize', 14, 'LineStyle', 'none', 'HorizontalAlignment', 'center');
    end



end



% Vuelve al directorio principal
cd('..');
cd('..');
