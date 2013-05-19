path = require 'path'
fs = require 'fs'
apiFolder = path.resolve 'apis'
patchFolder = path.resolve 'patches'
versionFile = path.resolve 'version.json'
patchPrefix = 'p'

exports.start = (app, cb) ->
    #bind apis
    files = fs.readdirSync apiFolder
    (require path.join(apiFolder, api)).bind app for api in files when path.extname(api) == '.js'
    
    #apply patches
    if fs.existsSync versionFile
        version = fs.readFileSync(versionFile).toString()
        patchNumber = JSON.parse(version).patch
    else
        patchNumber = 0

    console.log 'System was at patch ' + patchNumber

    patches = []
    files = fs.readdirSync patchFolder    
    patches.push patch for patch in files when path.extname(patch) == '.js'

    apply patches, patchNumber + 1, cb


#utilities
#TODO: may need to perform roll-back in case fail in the middle of applying patches
apply = (patches, next, cb) ->
    patch = patchPrefix + next + '.js'
    if patches.indexOf(patch) < 0
        #all patches have been applied
        #update patch number
        fs.writeFileSync versionFile, JSON.stringify { patch: next - 1 }
        console.log 'System is now at patch ' + (next - 1)
        cb()
    else
        #apply next patch
        console.log 'Applying patch ' + patch + '...'
        (require path.join(patchFolder, patch)).apply (err) ->
            if err
                #update patch number to last applied patch
                fs.writeFileSync versionFile, JSON.stringify { patch: next - 1 }
                console.log 'Stopped at patch ' + (next - 1)
                cb err
            else
                apply patches, next + 1, cb

    