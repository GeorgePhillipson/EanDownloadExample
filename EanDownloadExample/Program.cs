using System;
using System.Configuration;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Xml.Linq;

namespace DownloadEan
{
    static class Program
    {
        static void Main(string[] args)
        {
            DataFile.EanDataList();
        }
    }

    internal class LocationOfFileAndWhereToSave
    {
        public string RemoteUrl         { get; set; }
        public string LocalUrl          { get; set; }
        public string ExtractUrlFolder  { get; set; }
        public string NameOfTextFile    { get; set; }
    }

    internal static class DataFile
    {
        public static void EanDataList()
        {
            if (!File.Exists(ConfigurationManager.AppSettings["URLs"])) return;

            var doc = XDocument.Load(ConfigurationManager.AppSettings["URLs"]);

            var xmlFile = doc.Descendants("website").Select(xe => new LocationOfFileAndWhereToSave
            {
                RemoteUrl           = xe.Element("RemoteUrl") != null ? xe.Element("RemoteUrl").Value : "",
                LocalUrl            = xe.Element("LocalUrl") != null ? xe.Element("LocalUrl").Value : "",
                ExtractUrlFolder    = xe.Element("ExtractUrlFolder") != null ? xe.Element("ExtractUrlFolder").Value : "",
                NameOfTextFile      = xe.Element("NameOfTextFile") != null ? xe.Element("NameOfTextFile").Value : ""
            }).ToList();

            //Need to add code on line below to prevent the following error > The request was aborted: Could not create SSL/TLS secure channel
            //Only needed if using https
            ServicePointManager.SecurityProtocol = SecurityProtocolType.Ssl3 | SecurityProtocolType.Tls | SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;

            foreach (var element in xmlFile)
            {
                HttpWebRequest request = WebRequest.Create(element.RemoteUrl) as HttpWebRequest;

                if (request != null)
                {
                    request.Method = "HEAD";

                    HttpWebResponse response = request.GetResponse() as HttpWebResponse;

                    if (response != null)
                    {
                        DateTime lastModifiedRemoteFile = Convert.ToDateTime(response.LastModified);

                        FileInfo zipFile = new FileInfo(element.LocalUrl);

                        if (zipFile.Exists)
                        {
                            DateTime lastModifiedLocalFile = Convert.ToDateTime(zipFile.LastWriteTime);

                            if (lastModifiedLocalFile < lastModifiedRemoteFile)
                            {
                             bool successfail = DownloadZipFile.ExtractFile(element.RemoteUrl, element.LocalUrl, element.ExtractUrlFolder, element.NameOfTextFile, lastModifiedRemoteFile);

                                if (successfail)
                                {
                                    Console.WriteLine("Local file updated: " + element.LocalUrl);
                                }
                                else
                                {
                                    Console.WriteLine("Local file not updated: " + element.LocalUrl);
                                }
                            }
                            else
                            {
                                Console.WriteLine("Local file is newer:" + element.LocalUrl);
                            }

                        }
                        else
                        {
                            Console.WriteLine("Zip file does not exist: " + element.LocalUrl);
                            bool successfail = DownloadZipFile.ExtractFile(element.RemoteUrl, element.LocalUrl, element.ExtractUrlFolder, element.NameOfTextFile, lastModifiedRemoteFile);

                            if (successfail)
                            {
                                Console.WriteLine("Local file created: " + element.LocalUrl);
                            }
                            else
                            {
                                Console.WriteLine("Local file not created: " + element.LocalUrl + " " + "continue to next url");
                            }
                        }
                        response.Dispose();
                    }
                    else
                    {
                        //No response back from server so throw error
                        throw new ApplicationException("No response header from remote server");
                    }
                }
            }
        }
    }
}

internal static class DownloadZipFile
{
    public static bool ExtractFile(string remoteUrl, string localUrl, string extractUrl, string nameOfFile, DateTime lastModifiedRemoteFile)
    {
        try
        {
            using (WebClient webClient = new WebClientWithTimeout())
            {
                webClient.Headers.Add("user-agent","Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");
                webClient.DownloadFile(remoteUrl, localUrl);

                FileInfo zipFile = new FileInfo(localUrl);

                //Check that the file has downloaded.
                if (zipFile.Exists)
                {
                    FileInfo destFile = new FileInfo(nameOfFile);
                    if (destFile.Exists)
                    {
                        destFile.Delete();
                    }
                    ZipFile.ExtractToDirectory(localUrl, extractUrl);
                    //Need to set lastwritetime of local file to that of downloaded file, so that date and time match.
                    File.SetLastWriteTime(localUrl, lastModifiedRemoteFile);
                    Console.WriteLine("File created: " + localUrl);
                    return true;
                }
                Console.WriteLine("Cannot find dowloaded zip file: " + localUrl);
                return false;
            }
        }
        catch (Exception)
        {
            Console.WriteLine("Error downloading file: " + remoteUrl);
            return false;
        }
    }
}

internal class WebClientWithTimeout : WebClient
{
    protected override WebRequest GetWebRequest(Uri address)
    {
        WebRequest wr = base.GetWebRequest(address);
        //If you have a timeout error, change timeout setting here.
        wr.Timeout = 10000;
        return wr;
    }
}


