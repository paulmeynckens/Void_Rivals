using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using Mirror;

namespace UI
{
    public class EscapePanel : MonoBehaviour
    {
        [SerializeField] [Scene] string mainMenuScene = null;


        public void GoBackToMainMenu()
        {
            SceneManager.LoadScene(mainMenuScene);
        }
        public void QuitGame()
        {
            Application.Quit();
        }
    }
}
