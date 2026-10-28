# Fuentes y alcance de la boleta

Consulta realizada el **28/10/2026**. Los casos académicos usan exactamente los parámetros de la actividad. La app y el Excel aplican las mismas convenciones y redondean cada concepto a dos decimales antes de sumar.

| Dato | Valor usado | Fuente oficial | Consulta |
|---|---|---|---|
| RMV | S/ 1,230.00, vigente desde 01/10/2026 | [D.S. 015-2026-TR, artículo 1.2, El Peruano](https://busquedas.elperuano.pe/dispositivo/EX/2559163-1) | 28/10/2026 |
| Asignación familiar | 10% de la RMV, S/ 123.00 | [Guía de asignación familiar del MTPE, Ley 25129](https://cdn.www.gob.pe/uploads/document/file/2899623/guia_asignacion_familiar.pdf) | 28/10/2026 |
| ONP | 13% del total remunerativo | [SUNAT, conceptos afectos a ONP](https://orientacion.sunat.gob.pe/6722-10-conceptos-afectos-a-onp) y [aportes ONP y EsSalud](https://www.gob.pe/8076-declarar-y-pagar-aportes-de-trabajadores-del-hogar) | 28/10/2026 |
| EsSalud | 9%, a cargo del empleador | [EsSalud, aportes del seguro regular, Ley 26790](https://www.gob.pe/218-seguro-social-de-salud-aportes) | 28/10/2026 |
| Horas extras | Recargos de 25% y 35% | [SUNAT, trabajo en sobretiempo, D.S. 007-2002-TR, art. 10](https://orientacion.sunat.gob.pe/6722-10-conceptos-afectos-a-onp) | 28/10/2026 |
| AFP Ejemplo | Fondo 10%, comisión 1.60%, seguro 1.35% | Actividad_Grupo_B.docx, parámetros y casos 3–4. Valores académicos, no una AFP real | Guía del curso |
| AFP reales | Tasas de la tabla siguiente, devengue 2026-10 | [SBS, comisiones y primas del SPP](https://www.sbs.gob.pe/app/spp/empleadores/comisiones_spp/paginas/comision_prima.aspx) | 28/10/2026 |
| Mes y jornada de cálculo | 30 días y 8 horas | Actividad_Grupo_B.docx, reglas de cálculo | Guía del curso |
| Presentación | Tres bloques y neto; conceptos no aplicables en cero | Actividad_Grupo_B.docx, apartados 5 y 10 | Guía del curso |

## AFP con comisión sobre flujo

| AFP | Fondo | Comisión sobre flujo | Seguro |
|---|---:|---:|---:|
| Habitat | 10.00% | 1.47% | 1.37% |
| Integra | 10.00% | 1.55% | 1.37% |
| Prima | 10.00% | 1.60% | 1.37% |
| Profuturo | 10.00% | 1.69% | 1.37% |

La SBS distingue comisiones sobre flujo y sobre saldo. Aquí se modela la comisión sobre flujo. El seguro real tiene remuneración máxima asegurable; la tabla SBS de octubre indica S/ 12,732.70. El ejercicio simplifica el cálculo aplicando los tres porcentajes al total de remuneraciones. No implementa comisión sobre saldo, topes de prima ni renta de quinta categoría.

Las fórmulas de la guía también simplifican EsSalud sin base mínima y calculan el valor hora a partir del sueldo básico. Se mantienen esas reglas para que los cuatro casos coincidan con el enunciado. Estas diferencias se documentan para distinguir el modelo académico de una liquidación laboral completa.
