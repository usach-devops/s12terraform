#parametros infraestructura
name = "rggrupo2"
location = "westus"
ippublica = "ipgrupo2"
network = "vnetworkgrupo2"
subnet = "subnetgrupo2"
container = "containerregrupo2"
aks = "aksgrupo2"
networkinterface = "networkinterfacegrupo2"
nameinternal = "internalgrupo2"

#parametros tarea
kubernetesversion = "1.19.6"
#default node pool
enableautoscaling = true
nodomax = 3
nodomin = 1
#Adicional node pool
nodoadicionalname = "intadicional"
nodoadicionalpods = 80
nodoadicionallabel = {"tipo" = "Adicional"}