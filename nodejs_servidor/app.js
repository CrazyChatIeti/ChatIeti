const express = require('express')
const multer = require('multer');
const url = require('url')

const http = require('http');
const { log } = require('console');
const app = express()
const port = process.env.PORT || 3000
let stop = false;

// Configurar la rebuda d'arxius a través de POST
const storage = multer.memoryStorage(); // Guardarà l'arxiu a la memòria
const upload = multer({ storage: storage });

// Tots els arxius de la carpeta 'public' estàn disponibles a través del servidor
// http://localhost:3000/
// http://localhost:3000/images/imgO.png
app.use(express.static('public'))

// Configurar per rebre dades POST en format JSON
app.use(express.json());

// Activar el servidor HTTP
const httpServer = app.listen(port, appListen)
async function appListen() {
  console.log(`Listening for HTTP queries on: http://localhost:${port}`)
}

// Tancar adequadament les connexions quan el servidor es tanqui
process.on('SIGTERM', shutDown);
process.on('SIGINT', shutDown);
function shutDown() {
  console.log('Received kill signal, shutting down gracefully');
  httpServer.close()
  process.exit(0);
}

// Configurar direcció tipus 'GET' amb la URL ‘/itei per retornar codi HTML
// http://localhost:3000/ieti
app.get('/ieti', getIeti)
async function getIeti(req, res) {

  // Aquí s'executen totes les accions necessaries
  // - fer una petició a un altre servidor
  // - consultar la base de dades
  // - calcular un resultat
  // - cridar la linia de comandes
  // - etc.

  res.writeHead(200, { 'Content-Type': 'text/html' })
  res.end('<html><head><meta charset="UTF-8"></head><body><b>El pitjor</b> institut del món!</body></html>')
}

// Configurar direcció tipus 'GET' amb la URL ‘/llistat’ i paràmetres URL 
// http://localhost:3000/llistat?cerca=cotxes&color=blau
// http://localhost:3000/llistat?cerca=motos&color=vermell
app.get('/llistat', getLlistat)
async function getLlistat(req, res) {
  let query = url.parse(req.url, true).query;

  // Aquí s'executen totes les accions necessaries
  // però tenint en compte els valors dels variables de la URL
  // que guardem a l'objecte 'query'

  if (query.cerca && query.color) {
    // Així es retorna un text per parts (chunks)
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=UTF-8' });
    res.write(`result: "Aquí tens el llistat de ${query.cerca} de color ${query.color}"`)
    res.write(`\n list: ["item0", "item1", "item2"]`)
    res.end(`\n end: "Això és tot"`)
  } else {
    // Així es retorna un objecte JSON directament
    res.status(400).json({ result: "Paràmetres incorrectes" })
  }
}

// Configurar direcció tipus 'POST' amb la URL ‘/data'
// Enlloc de fer una crida des d'un navegador, fer servir 'curl'
// curl -X POST -F "data={\"type\":\"test\"}" -F "file=@package.json" http://localhost:3000/data
// curl -X POST -F "data={\"type\":\"conversa\", \"prompt\":\"tell me one word\"}" http://localhost:3000/data
// curl -X POST -F "data={\"type\":\"imatge\", \"prompt\":\"\", \"image\":\" \"}" http://localhost:3000/data
app.post('/data', upload.single('file'), async (req, res) => {
  // Processar les dades del formulari i l'arxiu adjunt
  const textPost = req.body;
  console.log(textPost);
  const uploadedFile = req.file;
  let objPost = {}

  try {
    objPost = JSON.parse(textPost.data);
  } catch (error) {
    res.status(400).send('Sol·licitud incorrecta.\n')
    console.log(error)
    return
  }

  // Aquí s'executen totes les accions necessaries
  // però tenint en compte el tipus de petició 
  // (en aquest exemple només 'test')

  // A l'exercici 'XatIETI' hi hauràn dos tipus de petició:
  // - 'conversa' que retornara una petició generada per 'mistral'
  // - 'imatge' que retornara una imatge generada per 'llava'

  if (objPost.type === 'test') {
    if (uploadedFile) {
      let fileContent = uploadedFile.buffer.toString('utf-8')
      console.log('Contingut de l\'arxiu adjunt:')
      console.log(fileContent)
    }
    res.writeHead(200, { 'Content-Type': 'text/plain; charset=UTF-8' })
    res.write("POST First line\n")
    await new Promise(resolve => setTimeout(resolve, 1000))
    res.write("POST Second line\n")
    await new Promise(resolve => setTimeout(resolve, 1000))
    res.end("POST Last line\n")
  }
  else if (objPost.type === 'conversa') {
    callMistralApi(objPost.prompt, (chunk) => {
      if (chunk) {
        let resp = JSON.parse(chunk)
        res.write(resp.response);
        if (resp.done || stop) {
          stop = false;
          res.end();
        }
      }
    });
  }
  else if (objPost.type === 'imatge') {
    let prompt = objPost.prompt == "" ? "What is in this picture?" : objPost.prompt
    callLlavaApi(prompt, objPost.image, (chunk) => {
      if (chunk) {
        let resp = JSON.parse(chunk)

        if (resp.done || stop) {
          stop = false;
          res.end();
        } else {
          res.write(resp.response);
        }
      }
    });
  }
  else if (objPost.type === 'stop') {
    stop = true;
    res.end();
  }
  else {
    res.status(400).send('Sol·licitud incorrecta.')
  }

  function callMistralApi(prompt, onDataCallback) {
    const data = JSON.stringify({
      model: 'mistral',
      prompt: prompt
    });

    const options = {
      hostname: 'localhost',
      port: 11434,
      path: '/api/generate',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': data.length
      }
    };

    const req = http.request(options, res => {
      res.on('data', chunk => {
        // Llamar al callback con cada fragmento de datos recibido
        onDataCallback(chunk);
      });
    });

    req.on('error', error => {
      console.error('Error al llamar a la API de Mistral:', error);
      // Manejar el error adecuadamente, tal vez con otro callback
    });

    req.write(data);
    req.end();
  }

  function callLlavaApi(prompt, image, onDataCallback) {
    const data = JSON.stringify({
      model: 'llava',
      prompt: prompt,
      images: [image]
    });

    const options = {
      hostname: 'localhost',
      port: 11434,
      path: '/api/generate',
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'Content-Length': data.length
      }
    };

    const req = http.request(options, res => {
      res.on('data', chunk => {
        // Llamar al callback con cada fragmento de datos recibido
        onDataCallback(chunk);
      });
    });

    req.on('error', error => {
      console.error('Error al llamar a la API de Llava:', error);
      // Manejar el error adecuadamente, tal vez con otro callback
    });

    req.write(data);
    req.end();
  }
})