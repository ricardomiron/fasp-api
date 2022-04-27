/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * Author:  altius
 * Created: 25-Apr-2022
 */

SET FOREIGN_KEY_CHECKS=0;
DELETE FROM ap_static_label_languages WHERE STATIC_LABEL_ID IN (SELECT l.`STATIC_LABEL_ID` FROM ap_static_label l WHERE l.`LABEL_CODE` IN ('static.tooltip.scenario','static.tooltip.NodeTitle',
'static.placeholder.modelingType',
'static.placeholder.usageTemplate'
));

DELETE l.* FROM ap_static_label l WHERE l.`LABEL_CODE` IN ('static.tooltip.scenario','static.tooltip.NodeTitle',
'static.placeholder.modelingType',
'static.placeholder.usageTemplate'
);
SET FOREIGN_KEY_CHECKS=1;

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='These Usage Names will appear when adding/editing a forecasting tree node in the \'Copy from Template\' dropdown' WHERE `STATIC_LABEL_LANGUAGE_ID`='200470'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Ces noms d\'utilisation apparaîtront lors de l\'ajout/de la modification d\'un nœud d\'arbre de prévision dans la liste déroulante \"Copier à partir du modèle\".' WHERE `STATIC_LABEL_LANGUAGE_ID`='200471'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Estos nombres de uso aparecerán al agregar/editar un nodo de árbol de pronóstico en el menú desplegable \'Copiar de plantilla\'' WHERE `STATIC_LABEL_LANGUAGE_ID`='200472'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Esses nomes de uso aparecerão ao adicionar/editar um nó de árvore de previsão no menu suspenso \'Copiar do modelo\'' WHERE `STATIC_LABEL_LANGUAGE_ID`='200473'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Link the changes in this node to the changes in another node in the same level. If a row is greyed out, edit on source (or \'from\') node.' WHERE `STATIC_LABEL_LANGUAGE_ID`='200322'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Liez les modifications de ce nœud aux modifications d\un autre nœud du même niveau. Si une ligne est grisée, modifiez-la sur le nœud source (ou « de »).' WHERE `STATIC_LABEL_LANGUAGE_ID`='200323'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Vincule los cambios en este nodo a los cambios en otro nodo en el mismo nivel. Si una fila está atenuada, edite en el nodo fuente (o \'desde\').' WHERE `STATIC_LABEL_LANGUAGE_ID`='200324'; 

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Vincule as mudanças neste nó às mudanças em outro nó no mesmo nível. Se uma linha estiver acinzentada, edite no nó de origem (ou \'de\').' WHERE `STATIC_LABEL_LANGUAGE_ID`='200325'; 

INSERT INTO fasp.ap_static_label(STATIC_LABEL_ID,LABEL_CODE,ACTIVE) VALUES ( NULL,'static.importIntoQATSupplyPlan.conversionFactor','1');
SELECT MAX(l.STATIC_LABEL_ID) INTO @MAX FROM ap_static_label l ;

INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,1,'Conversion Factor (Forecast Planning Unit to Supply Plan)');-- en
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,2,'Facteur de conversion (prévision en plan dapprovisionnement)');
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,4,'Fator de conversão (previsão para plano de fornecimento)');
INSERT INTO ap_static_label_languages VALUES(NULL,@MAX,3,'Factor de conversión (pronóstico a plan de suministro)');



update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='NOTE:  The minimum values needed to get correct graphs and reports for the various features are below:\n* TES, Holt-Winters:  Needs at least 24 months of actual consumption data\n* ARIMA:  Needs at least 14 months of actual consumption data\n* Moving Average, Semi-Averages, and Linear Regression:  Needs at least 3 months of actual consumption data'
where l.LABEL_CODE='static.tree.minDataRequiredToExtrapolate' and ll.LANGUAGE_ID=1;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='REMARQUE : Les valeurs minimales nécessaires pour obtenir des graphiques et des rapports corrects pour les différentes fonctionnalités sont les suivantes :\n* TES, Holt-Winters : nécessite au moins 24 mois de données de consommation réelle\n* ARIMA : nécessite au moins 14 mois de données de consommation réelle\n* Moyenne mobile, semi-moyennes et régression linéaire : nécessite au moins 3 mois de données de consommation réelle'
where l.LABEL_CODE='static.tree.minDataRequiredToExtrapolate' and ll.LANGUAGE_ID=2;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='NOTA: Los valores mínimos necesarios para obtener gráficos e informes correctos para las diversas funciones se encuentran a continuación:\n* TES, Holt-Winters: necesita al menos 24 meses de datos de consumo real\n* ARIMA: necesita al menos 14 meses de datos de consumo real\n* Promedio móvil, semipromedios y regresión lineal: necesita al menos 3 meses de datos de consumo real'
where l.LABEL_CODE='static.tree.minDataRequiredToExtrapolate' and ll.LANGUAGE_ID=3;

update ap_static_label l 
left join ap_static_label_languages ll on l.STATIC_LABEL_ID=ll.STATIC_LABEL_ID
set ll.LABEL_TEXT='OBSERVAÇÃO: os valores mínimos necessários para obter gráficos e relatórios corretos para os vários recursos estão abaixo:\n* TES, Holt-Winters: precisa de pelo menos 24 meses de dados de consumo reais\n* ARIMA: precisa de pelo menos 14 meses de dados de consumo reais\n* Média Móvel, Semi-Médias e Regressão Linear: Precisa de pelo menos 3 meses de dados de consumo real'
where l.LABEL_CODE='static.tree.minDataRequiredToExtrapolate' and ll.LANGUAGE_ID=4;

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Whereas a moving average weighs each data point equally, exponential smoothing uses older data at exponentially decreasing weights over time. Triple exponential smoothing applies smoothing to the level (alpha), trend (beta), and seasonality (gamma) - parameters are set between 0 and 1, with values close to 1 favoring recent values and values close to 0 favoring past values.\r\nConfidence interval:  between 0% and 100% (exclusive) e.g. 90% confidence level indicates 90% of future points are to fall within this radius from prediction.\r\nAlpha (level), beta (trend), gamma (seasonality): between 0 and 1, with values close to 1 favoring recent values and values close to 0 favoring past values. \r\nSee \'Show Guidance\' for more.\r\n' WHERE `STATIC_LABEL_LANGUAGE_ID`='200570';

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Alors qu\'une moyenne mobile pèse chaque point de données de manière égale, le lissage exponentiel utilise des données plus anciennes à des poids décroissants de manière exponentielle au fil du temps. Le triple lissage exponentiel applique le lissage au niveau (alpha), à la tendance (bêta) et à la saisonnalité (gamma) - les paramètres sont définis entre 0 et 1, les valeurs proches de 1 favorisant les valeurs récentes et les valeurs proches de 0 favorisant les valeurs passées.\r\nIntervalle de confiance : entre 0% et 100% (exclusif) ex. Un niveau de confiance de 90 % indique que 90 % des points futurs doivent se situer dans ce rayon de prédiction.\r\nAlpha (niveau), beta (tendance), gamma (saisonnalité) : entre 0 et 1, avec des valeurs proches de 1 favorisant les valeurs récentes et des valeurs proches de 0 favorisant les valeurs passées.\r\nVoir \'Afficher le guidage\' pour plus d\'informations.\r\n' WHERE `STATIC_LABEL_LANGUAGE_ID`='200571';

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Mientras que un promedio móvil pondera cada punto de datos por igual, el suavizado exponencial utiliza datos más antiguos con ponderaciones que disminuyen exponencialmente a lo largo del tiempo. El suavizado exponencial triple aplica suavizado al nivel (alfa), la tendencia (beta) y la estacionalidad (gamma): los parámetros se establecen entre 0 y 1, con valores cercanos a 1 que favorecen los valores recientes y valores cercanos a 0 que favorecen los valores pasados.\r\nIntervalo de confianza: entre 0% y 100% (exclusivo) ej. El nivel de confianza del 90% indica que el 90% de los puntos futuros caerán dentro de este radio de predicción.\r\nAlfa (nivel), beta (tendencia), gamma (estacionalidad): entre 0 y 1, con valores cercanos a 1 favoreciendo valores recientes y valores cercanos a 0 favoreciendo valores pasados.\r\nConsulte \'Mostrar orientación\' para obtener más información.' WHERE `STATIC_LABEL_LANGUAGE_ID`='200572';

UPDATE `fasp`.`ap_static_label_languages` SET `LABEL_TEXT`='Enquanto uma média móvel pesa cada ponto de dados igualmente, a suavização exponencial usa dados mais antigos com pesos exponencialmente decrescentes ao longo do tempo. A suavização exponencial tripla aplica a suavização ao nível (alfa), tendência (beta) e sazonalidade (gama) - os parâmetros são definidos entre 0 e 1, com valores próximos de 1 favorecendo valores recentes e valores próximos de 0 favorecendo valores passados.\r\nIntervalo de confiança: entre 0% e 100% (exclusivo) ex. O nível de confiança de 90% indica que 90% dos pontos futuros devem cair dentro desse raio de previsão.\r\nAlfa (nível), beta (tendência), gama (sazonalidade): entre 0 e 1, com valores próximos de 1 favorecendo valores recentes e valores próximos de 0 favorecendo valores passados.\r\nConsulte \'Mostrar Orientação\' para mais informações.' WHERE `STATIC_LABEL_LANGUAGE_ID`='200573';

