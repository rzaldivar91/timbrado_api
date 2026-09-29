escuela_kemper  = Cliente.create!(nombre: "ESCUELA KEMPER URGATE", rfc: "EKU9003173C9")
jimenes_estrada = Cliente.create!(nombre: "JIMENEZ ESTRADA SALAS", rfc: "JES900109Q90")
kernel_industria = Cliente.create!(nombre: "KERNEL INDUSTRIA JUGUETERA", rfc: "KIJ0906199R1")

factura1 = Factura.create!(cliente: escuela_kemper,  folio: "A1", total: 1000, estatus: "vencida", fecha_emision: 2.days.ago)
factura2 = Factura.create!(cliente: escuela_kemper,  folio: "A2", total: 500, estatus: "vencida", fecha_emision: 2.days.ago)
factura3 = Factura.create!(cliente: jimenes_estrada, folio: "B1", total: 2000, estatus: "vencida", fecha_emision: 2.days.ago)
Factura.create!(cliente: jimenes_estrada,      folio: "B2", total: 800, estatus: "vigente", fecha_emision: Date.current)
Factura.create!(cliente: kernel_industria,      folio: "C1", total: 1500.50, estatus: "vencida", fecha_emision: 2.days.ago)

Pago.create!(factura: factura1, monto: 400, fecha_pago: 1.days.ago)
Pago.create!(factura: factura2, monto: 500, fecha_pago: 1.days.ago)
Pago.create!(factura: factura3, monto: 700, fecha_pago: 1.days.ago)
Pago.create!(factura: factura3, monto: 600, fecha_pago: 1.days.ago)
