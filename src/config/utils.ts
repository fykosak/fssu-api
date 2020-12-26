export function getConfigString(name: string): string
{
    let variable = process.env[name];
    if (variable == null)
        throw Error('Variable ' + name + ' (string) was not found in the configuration file.');
    return variable;
}

export function getConfigInt(name: string): number
{
    let variable = process.env[name];
    if (variable == null)
        throw Error('Variable ' + name + ' (int) was not found in the configuration file.')
    let intVariable = parseInt(variable);
    if (intVariable == NaN)
        throw Error('Variable ' + name + ' (int) could not be parsed to the int.')
    return intVariable;
}