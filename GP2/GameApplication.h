#pragma once
#include "Win32Window.h"
#include <D3D10.h>
#include <D3DX10.h>

class CGameApplication
{
public:
	CGameApplication(void);
	~CGameApplication(void);
	bool init();
	void run();
public:
	bool initGame();
	bool initGraphics();
	bool initWindow();
	void render();
	void update();
public:
	ID3D10Device * m_pD3D10Device;
	IDXGISwapChain * m_pSwapChain;
	ID3D10RenderTargetView * m_pRenderTargetView;

	ID3D10DepthStencilView*m_pDepthStencilView;
	ID3D10Texture2D*m_pDepthStencilTexture;

	CWin32Window * m_pWindow;

		//Vertex Buffer - BMD
	ID3D10Buffer*           m_pVertexBuffer;
	ID3D10InputLayout*      m_pVertexLayout;

	ID3D10Buffer*           m_pIndexBuffer;
	


	//Effect - BMD
	ID3D10Effect*           m_pEffect;
	ID3D10EffectTechnique*  m_pTechnique;
	ID3D10EffectMatrixVariable*m_pWorldMatrixVariable;
	ID3D10EffectMatrixVariable*m_pViewMatrixVariable;
	ID3D10EffectMatrixVariable*m_pProjectionMatrixVariable;

	D3DXMATRIX m_matWorld;
	D3DXMATRIX m_matScale;
	D3DXMATRIX m_matRotation;
	D3DXMATRIX m_matTranslation;

	D3DXVECTOR3 m_vecPosition;
	D3DXVECTOR3 m_vecRotation;
	D3DXVECTOR3 m_vecScale;

	ID3D10EffectShaderResourceVariable*m_pDiffuseTextureVariable;
	ID3D10ShaderResourceView*m_pTextureShaderResource;

	


	D3DXMATRIX m_matView;
	D3DXMATRIX m_matProjection;
};